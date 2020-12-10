set --global fisher_version 4.1.0

function fisher -a cmd -d "Fish plugin manager"
    set --query fisher_path || set --local fisher_path $__fish_config_dir
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

            if not set --query argv[2]
                if test "$cmd" != update || test ! -e $fish_plugins
                    echo "fisher: Not enough arguments for command: \"$cmd\"" >&2 && return 1
                end
                set arg_plugins (string trim <$fish_plugins)
            end

            for plugin in $arg_plugins
                test -e "$plugin" && set plugin (realpath $plugin)
                contains -- "$plugin" $new_plugins || set --append new_plugins $plugin
            end

            if set --query argv[2]
                for plugin in $new_plugins
                    if contains -- "$plugin" $old_plugins
                        if test "$cmd" = remove
                            set --append remove_plugins $plugin
                        else
                            set --append update_plugins $plugin
                        end
                    else if test "$cmd" != install
                        echo "fisher: Plugin not installed: \"$plugin\"" >&2 && return 1
                    else
                        set --append install_plugins $plugin
                    end
                end
            else
                for plugin in $new_plugins
                    if contains -- "$plugin" $old_plugins
                        set --append update_plugins $plugin
                    else
                        set --append install_plugins $plugin
                    end
                end

                for plugin in $old_plugins
                    if not contains -- "$plugin" $new_plugins
                        set --append remove_plugins $plugin
                    end
                end
            end

            set --local pid_list
            set --local source_plugins
            set --local fetch_plugins $update_plugins $install_plugins
            echo -e "\x1b[1mfisher $cmd version $fisher_version\x1b[22m"

            for plugin in $fetch_plugins
                set --local source (command mktemp -d)
                set --append source_plugins $source

                command mkdir -p $source/{completions,conf.d,functions}

                fish -c "
                if test -e $plugin
                    command cp -Rf $plugin/* $source
                else 
                    set temp (command mktemp -d)
                    set name (string split \@ $plugin) || set name[2] HEAD
                    set url https://codeload.github.com/\$name[1]/tar.gz/\$name[2]
                    set --query fisher_user_api_token && set opts -u $fisher_user_api_token

                    echo -e \"Fetching \x1b[4m\$url\x1b[24m\"
                    if command curl $opts --silent \$url | tar --extract --gzip --directory \$temp --file -
                        command cp -Rf \$temp/*/* $source
                    else
                        echo fisher: Invalid plugin name or host unavailable: \\\"$plugin\\\" >&2
                        command rm -rf $source
                    end
                    command rm -rf \$temp
                end

                test ! -e $source && exit
                command mv -f (string match --entire --regex -- \.fish\\\$ $source/*) $source/functions 2>/dev/null" &

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
                    set --local plugin_files_var _fisher_(string escape --style=var $plugin)_files

                    if contains -- "$plugin" $remove_plugins && set --erase _fisher_plugins[$index]
                        for file in (string match --entire --regex -- "conf\.d/" $$plugin_files_var)
                            emit (string replace --all --regex -- '^.*/|\.fish$' "" $file)_uninstall
                        end
                        echo -es "Removing \x1b[1m$plugin\x1b[22m" \n"         "$$plugin_files_var
                    end

                    command rm -rf $$plugin_files_var
                    functions --erase (string match --entire --regex -- "functions/" $$plugin_files_var \
                        | string replace --all --regex -- '^.*/|\.fish$' "")
                    set --erase $plugin_files_var
                end
            end

            if set --query update_plugins[1] || set --query install_plugins[1]
                command mkdir -p $fisher_path/{functions,conf.d,completions}
            end

            for plugin in $update_plugins $install_plugins
                set --local source $source_plugins[(contains --index -- "$plugin" $fetch_plugins)]
                set --local files $source/{functions,conf.d,completions}/*
                set --local plugin_files_var _fisher_(string escape --style=var $plugin)_files
                set --query files[1] && set -U $plugin_files_var (string replace $source $fisher_path $files)

                for file in (string replace -- $source "" $files)
                    command cp -Rf $source/$file $fisher_path/$file
                end

                contains -- $plugin $_fisher_plugins || set -Ua _fisher_plugins $plugin
                contains -- $plugin $install_plugins && set --local event "install" || set --local event "update"
                echo -es "Installing \x1b[1m$plugin\x1b[22m" \n"           "$$plugin_files_var

                for file in (string match --entire --regex -- "[functions/|conf\.d/].*fish\$" $$plugin_files_var)
                    source $file
                    if string match --quiet --regex -- "conf\.d/" $file
                        emit (string replace --all --regex -- '^.*/|\.fish$' "" $file)_$event
                    end
                end
            end

            command rm -rf $source_plugins
            functions --query fish_prompt || source $__fish_data_dir/functions/fish_prompt.fish

            set --query _fisher_plugins[1] || set --erase _fisher_plugins
            set --query _fisher_plugins && printf "%s\n" $_fisher_plugins >$fish_plugins || command rm -f $fish_plugins

            set --local total (count $install_plugins) (count $update_plugins) (count $remove_plugins)
            test "$total" != "0 0 0" && echo (string join ", " (
                test $total[1] = 0 || echo "Installed $total[1]") (
                test $total[2] = 0 || echo "Updated $total[2]") (
                test $total[3] = 0 || echo "Removed $total[3]")
            ) "plugin/s"
        case \*
            echo "fisher: Unknown flag or command: \"$cmd\" (see `fisher -h`)" >&2 && return 1
    end
end

## Migrations ##
if functions --query _fisher_self_update || test -e $__fish_config_dir/fishfile # 3.x
    function _fisher_migrate
        function _fisher_complete
            fisher install jorgebucaran/fisher >/dev/null 2>/dev/null
            functions --erase _fisher_complete
        end
        set --query XDG_DATA_HOME || set XDG_DATA_HOME ~/.local/share
        set --query XDG_CACHE_HOME || set XDG_CACHE_HOME ~/.cache
        set --query XDG_CONFIG_HOME || set XDG_CONFIG_HOME ~/.config
        set --query fisher_path || set fisher_path $__fish_config_dir
        test -e $__fish_config_dir/fishfile && command awk '/#|^gitlab|^ *$/ { next } $0' <$__fish_config_dir/fishfile >>$__fish_config_dir/fish_plugins
        command rm -rf $__fish_config_dir/fishfile $fisher_path/{conf.d,completions}/fisher.fish {$XDG_DATA_HOME,$XDG_CACHE_HOME,$XDG_CONFIG_HOME}/fisher
        functions --erase _fisher_migrate _fisher_copy_user_key_bindings _fisher_ls _fisher_fmt _fisher_self_update _fisher_self_uninstall _fisher_commit _fisher_parse _fisher_fetch _fisher_add _fisher_rm _fisher_jobs _fisher_now _fisher_help
        fisher update
    end
    echo "Upgrading to Fisher $fisher_version -- learn more at" (set_color --bold --underline)"https://git.io/fisher-4"(set_color normal)
    _fisher_migrate >/dev/null 2>/dev/null
end

function _fisher_fish_postexec --on-event fish_postexec
    if functions --query _fisher_list
        fisher update >/dev/null 2>/dev/null
        set --query XDG_DATA_HOME || set --local XDG_DATA_HOME ~/.local/share
        test -e $XDG_DATA_HOME/fisher && rm -rf $XDG_DATA_HOME/fisher
        functions --erase _fisher_list _fisher_plugin_parse
        set --erase fisher_data
    end
    functions --erase _fisher_fish_postexec
end