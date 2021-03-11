function fisher --argument-names cmd --description "A plugin manager for Fish"
    set --query fisher_path || set --local fisher_path $__fish_config_dir
    set --local fisher_version 4.3.0
    set --local fish_plugins $__fish_config_dir/fish_plugins

    switch "$cmd"
        case -v --version
            echo "fisher, version $fisher_version"
        case "" -h --help
            echo "Usage: fisher install <plugins...>  Install plugins"
            echo "       fisher remove  <plugins...>  Remove installed plugins"
            echo "       fisher update  <plugins...>  Update installed plugins"
            echo "       fisher update                Update all installed plugins"
            echo "       fisher list    [<regex>]     List installed plugins matching regex"
            echo "Options:"
            echo "       -v or --version  Print version"
            echo "       -h or --help     Print this help message"
        case ls list
            string match --entire --regex -- "$argv[2]" $_fisher_plugins
        case install update remove
            isatty || read --local --null --array stdin && set --append argv $stdin

            set --local install_plugins
            set --local update_plugins
            set --local remove_plugins
            set --local arg_plugins $argv[2..-1]
            set --local old_plugins $_fisher_plugins
            set --local new_plugins

            if ! set --query argv[2]
                if test "$cmd" != update
                    echo "fisher: Not enough arguments for command: \"$cmd\"" >&2 && return 1
                else if test ! -e $fish_plugins
                    echo "fisher: \"$fish_plugins\" file not found: \"$cmd\"" >&2 && return 1
                end
                set arg_plugins (string match --regex -- '^[^\s]+$' <$fish_plugins)
            end

            for plugin in $arg_plugins
                test -e "$plugin" && set plugin (realpath $plugin)
                contains -- "$plugin" $new_plugins || set --append new_plugins $plugin
            end

            if set --query argv[2]
                for plugin in $new_plugins
                    if contains -- "$plugin" $old_plugins
                        test "$cmd" = remove &&
                            set --append remove_plugins $plugin ||
                            set --append update_plugins $plugin
                    else if test "$cmd" = install
                        set --append install_plugins $plugin
                    else
                        echo "fisher: Plugin not installed: \"$plugin\"" >&2 && return 1
                    end
                end
            else
                for plugin in $new_plugins
                    contains -- "$plugin" $old_plugins &&
                        set --append update_plugins $plugin ||
                        set --append install_plugins $plugin
                end

                for plugin in $old_plugins
                    contains -- "$plugin" $new_plugins || set --append remove_plugins $plugin
                end
            end

            set --local pid_list
            set --local source_plugins
            set --local fetch_plugins $update_plugins $install_plugins
            echo (set_color --bold)fisher $cmd version $fisher_version(set_color normal)

            for plugin in $fetch_plugins
                set --local source (command mktemp -d)
                set --append source_plugins $source

                command mkdir -p $source/{completions,conf.d,functions}

                fish --command "
                    if test -e $plugin
                        command cp -Rf $plugin/* $source
                    else
                        set temp (command mktemp -d)
                        set name (string split \@ $plugin) || set name[2] HEAD
                        set url https://codeload.github.com/\$name[1]/tar.gz/\$name[2]

                        echo Fetching (set_color --underline)\$url(set_color normal)

                        if curl --silent \$url | tar -xzC \$temp -f - 2>/dev/null
                            command cp -Rf \$temp/*/* $source
                        else
                            echo fisher: Invalid plugin name or host unavailable: \\\"$plugin\\\" >&2
                            command rm -rf $source
                        end
                        command rm -rf \$temp
                    end

                    set files $source/* && string match --quiet --regex -- .+\.fish\\\$ \$files
                " &

                set --append pid_list (jobs --last --pid)
            end

            wait $pid_list 2>/dev/null

            for plugin in $fetch_plugins
                if set --local source $source_plugins[(contains --index -- "$plugin" $fetch_plugins)] && test ! -e $source
                    if set --local index (contains --index -- "$plugin" $install_plugins)
                        set --erase install_plugins[$index]
                    else
                        set --erase update_plugins[(contains --index -- "$plugin" $update_plugins)]
                    end
                end
            end

            for plugin in $update_plugins $remove_plugins
                if set --local index (contains --index -- "$plugin" $_fisher_plugins)
                    set --local plugin_files_var _fisher_(string escape --style=var -- $plugin)_files

                    if contains -- "$plugin" $remove_plugins
                        for name in (string replace --filter --regex -- '.+/conf\.d/([^/]+)\.fish$' '$1' $$plugin_files_var)
                            emit {$name}_uninstall
                        end
                        printf "%s\n" Removing\ (set_color red --bold)$plugin(set_color normal) "         "$$plugin_files_var
                    end

                    command rm -rf $$plugin_files_var
                    functions --erase (string replace --filter --regex -- '.+/functions/([^/]+)\.fish$' '$1' $$plugin_files_var)

                    for name in (string replace --filter --regex -- '.+/completions/([^/]+)\.fish$' '$1' $$plugin_files_var)
                        complete --erase --command $name
                    end

                    set --erase _fisher_plugins[$index]
                    set --erase $plugin_files_var
                end
            end

            if set --query update_plugins[1] || set --query install_plugins[1]
                command mkdir -p $fisher_path/{functions,conf.d,completions}
            end

            for plugin in $update_plugins $install_plugins
                set --local source $source_plugins[(contains --index -- "$plugin" $fetch_plugins)]
                set --local files $source/{functions,conf.d,completions}/*

                if set --local index (contains --index -- $plugin $install_plugins)
                    set --local user_files $fisher_path/{functions,conf.d,completions}/*
                    set --local conflict_files

                    for file in (string replace -- $source/ $fisher_path/ $files)
                        contains -- $file $user_files && set --append conflict_files $file
                    end

                    if set --query conflict_files[1] && set --erase install_plugins[$index]
                        echo -s "fisher: Cannot install \"$plugin\": please remove or move conflicting files first:" \n"        "$conflict_files >&2
                        continue
                    end
                end

                for file in (string replace -- $source/ "" $files)
                    command cp -Rf $source/$file $fisher_path/$file
                end

                set --local plugin_files_var _fisher_(string escape --style=var -- $plugin)_files
                set --query files[1] && set --universal $plugin_files_var (string replace -- $source $fisher_path $files)

                contains -- $plugin $_fisher_plugins || set --universal --append _fisher_plugins $plugin
                contains -- $plugin $install_plugins && set --local event install || set --local event update

                printf "%s\n" Installing\ (set_color --bold)$plugin(set_color normal) "           "$$plugin_files_var

                for file in (string match --regex -- '.+/[^/]+\.fish$' $$plugin_files_var)
                    source $file
                    if set --local name (string replace --regex -- '.+conf\.d/([^/]+)\.fish$' '$1' $file)
                        emit {$name}_$event
                    end
                end
            end

            command rm -rf $source_plugins

            set --query _fisher_plugins[1] || set --erase _fisher_plugins
            set --query _fisher_plugins &&
                printf "%s\n" $_fisher_plugins >$fish_plugins ||
                command rm -f $fish_plugins

            set --local total (count $install_plugins) (count $update_plugins) (count $remove_plugins)
            test "$total" != "0 0 0" && echo (string join ", " (
                test $total[1] = 0 || echo "Installed $total[1]") (
                test $total[2] = 0 || echo "Updated $total[2]") (
                test $total[3] = 0 || echo "Removed $total[3]")
            ) plugin/s
        case \*
            echo "fisher: Unknown command: \"$cmd\"" >&2 && return 1
    end
end

## Migrations ##
function _fisher_fish_postexec --on-event fish_postexec
    if functions --query _fisher_list
        fisher update >/dev/null 2>/dev/null
        set --query XDG_DATA_HOME || set --local XDG_DATA_HOME ~/.local/share
        test -e $XDG_DATA_HOME/fisher && command rm -rf $XDG_DATA_HOME/fisher
        functions --erase _fisher_list _fisher_plugin_parse
        set --erase fisher_data
    end
    functions --erase _fisher_fish_postexec
end
