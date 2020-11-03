set -g fisher_version 4.0.0

function fisher -a cmd -d "fish plugin manager"
    set -q XDG_DATA_HOME || set XDG_DATA_HOME ~/.local/share
    set -q fisher_path || set -g fisher_path $__fish_config_dir
    set -g fisher_data $XDG_DATA_HOME/fisher
    set -g fish_plugins $__fish_config_dir/fish_plugins

    switch "$cmd"
        case -v --version
            echo "fisher, version $fisher_version"
        case "" -h {--,}help
            echo "usage: fisher install <plugins...>   install plugins"
            echo "       fisher update [<plugins...>]  update installed plugins"
            echo "       fisher remove <plugins...>    remove installed plugins"
            echo "       fisher list [<regex>]         list installed plugins matching <regex>"
            echo "options:"
            echo "       -v or --version  print fisher version"
            echo "       -h or --help     print this help message"
        case list
            _fisher_list | string match --entire --regex -- "$argv[2]"
        case install update remove
            set -l install_plugins
            set -l update_plugins
            set -l remove_plugins
            set -l old_plugins (_fisher_list)
            set -q fisher_user_api_token && set -l curl_opts -u $fisher_user_api_token
            set -l pid_list

            if not isatty
                read -lz --list list
                set -a argv $list
            end

            if test (count $argv) = 1
                if test "$cmd" != update
                    echo "fisher: invalid number of arguments (see `fisher --help`)" >&2 && return 1
                end

                test -e $fish_plugins && set -l new_plugins (_fisher_plugin_parse (string trim <$fish_plugins))
                for plugin in $new_plugins
                    if contains -- "$plugin" $old_plugins
                        set -a update_plugins $plugin
                    else
                        set -a install_plugins $plugin
                    end
                end
                for plugin in $old_plugins
                    if not contains -- "$plugin" $new_plugins
                        set -a remove_plugins $plugin
                    end
                end
            else
                for plugin in (_fisher_plugin_parse $argv[2..-1])
                    if contains -- "$plugin" $old_plugins
                        if test "$cmd" = install
                            echo "fisher: \"$plugin\" is already installed (try `fisher update $plugin`)" >&2 && return 1
                        else if test "$cmd" = update 
                            set -a update_plugins $plugin
                        else 
                            set -a remove_plugins $plugin
                        end
                    else
                        if test "$cmd" = install 
                            set -a install_plugins $plugin
                        else if test "$cmd" = update || test "$cmd" = remove 
                            echo "fisher: plugin \"$plugin\" not found (is this a valid plugin?)" >&2 && return 1
                        end
                    end
                end
            end

            for plugin in $install_plugins $update_plugins
                if test -e $plugin
                    command mkdir -p $fisher_data/@$USER
                    set -l name (string replace --all --regex '^.*/|\.fish$' "" $plugin)
                    echo "fetching $plugin" >&2
                    if test ! -L $fisher_data/@$USER/$name
                        command ln -sf $plugin $fisher_data/@$USER/$name
                    end
                    continue
                end

                fish -c "
                set name_tag (string split \@ $plugin) || set name_tag[2] HEAD
                set -l url https://codeload.github.com/\$name_tag[1]/tar.gz/\$name_tag[2]
                set -l tmp (command mktemp -d)
                echo fetching \$url >&2

                if command curl $curl_opts -Ss -w \"\" \$url 2>&1 | command tar -xzf- -C \$tmp 2>/dev/null   
                    command rm -rf $fisher_data/$plugin
                    command mkdir -p $fisher_data/$plugin
                    command cp -rf \$tmp/*/* $fisher_data/$plugin
                    command rm -rf \$tmp
                else
                    echo fisher: cannot install \"$plugin\" -- is this a valid plugin\? >&2
                end
                " >/dev/null &

                set -a pid_list $last_pid
            end
            wait $pid_list 2>/dev/null

            for plugin in $install_plugins $update_plugins
                set -l target $fisher_data/$plugin
                if test -e $plugin
                    set target $fisher_data/@$USER/(string replace --all --regex '^.*/|\.fish$' "" $plugin)
                end

                test -e $target || continue

                contains -- "$plugin" $install_plugins && set -l event install || set -l event update

                command cp -R $target/{*.fish,functions,completions,conf.d} $fisher_path 2>/dev/null

                for file in $target/{,functions,conf.d}/*.fish
                    set -l source (realpath $file | string replace --all $target $fisher_path)
                    echo "sourcing $source" >&2
                    source $source
                    if string match --quiet --regex -- conf\.d/ $file
                        emit (string replace --all --regex '^.*/|\.fish$' "" $file)_$event
                    end
                end
            end

            for plugin in $remove_plugins
                set -l target $fisher_data/$plugin
                if test -e $plugin
                    set target $fisher_data/@$USER/(string replace --all --regex '^.*/|\.fish$' "" $plugin)
                end

                set -l fncs $target/{functions,}/*.fish
                for file in $target/{conf.d,completions}/* $fncs
                    if string match --quiet --regex -- conf\.d/ $file
                        emit (string replace --all --regex '^.*/|\.fish$' "" $file)_uninstall
                    end
                    set -l file (string replace --all $target/ $fisher_path/ $file)
                    echo "removing $file" >&2
                    command rm -rf $file
                end

                command rm -rf $target
                functions -e (string replace --all --regex '^.*/|\.fish$' "" $fncs)
                functions -q fish_prompt || source $__fish_data_dir/functions/fish_prompt.fish
            end

            if test -e $fisher_path/completions/fisher.fish
                source $fisher_path/completions/fisher.fish 2>/dev/null
            end

            _fisher_list >$fish_plugins

            test -s $fish_plugins || test "$cmd" = remove 
        case \*
            if contains -- "$cmd" add ls rm
                echo "fisher: the `$cmd` command is deprecated (see `fisher --help`)" >&2
            else 
                echo "fisher: unknown flag or command \"$cmd\"" >&2
            end
            return 1
    end
end

function _fisher_plugin_parse
    for plugin in $argv
        switch $plugin
            case \~\*
                string replace --all --regex '^~' ~ "$plugin"
            case \*/ /\* \*../\* ./\*
                realpath $plugin 2>/dev/null
            case \*/\*
                echo $plugin
            case ""
            case \*
                _fisher_plugin_parse ./$plugin
        end
    end
end

function _fisher_list
    for path in $fisher_data/*/*
        if test -L $path
            realpath $path
        else 
            string replace --all $fisher_data/ "" $path
        end 
    end
end

if functions -q _fisher_self_update || test -e $__fish_config_dir/fishfile
    # Handle fisher 4 migration paths:
    # - self-update → source → _fisher_complete
    # - curl | source && fisher install ..
    function _fisher_migrate
        function _fisher_complete
            functions -e _fisher_complete
            fisher install jorgebucaran/fisher
        end

        set -q XDG_DATA_HOME || set XDG_DATA_HOME ~/.local/share
        set -q XDG_CACHE_HOME || set XDG_CACHE_HOME ~/.cache
        set -q XDG_CONFIG_HOME || set XDG_CONFIG_HOME ~/.config
        set -q fisher_path || set fisher_path $__fish_config_dir

        if test -e $__fish_config_dir/fishfile
            command awk '/#|^gitlab|^ *$/ { next } $0' <$__fish_config_dir/fishfile >>$__fish_config_dir/fish_plugins
        end

        command rm -rf $__fish_config_dir/fishfile $fisher_path/{conf.d,completions}/fisher.fish {$XDG_DATA_HOME,$XDG_CACHE_HOME,$XDG_CONFIG_HOME}/fisher
        functions -e _fisher_migrate _fisher_copy_user_key_bindings _fisher_ls _fisher_fmt _fisher_self_update _fisher_self_uninstall _fisher_commit _fisher_parse _fisher_fetch _fisher_add _fisher_rm _fisher_jobs _fisher_now _fisher_help
        
        echo "latest changes: https://git.io/fisher-latest" >&2
        echo "bootstrapping fisher $fisher_version for the first time" >&2
        fisher update
    end
    _fisher_migrate
end