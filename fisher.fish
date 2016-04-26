function fisher
    set -g fisher_version "2.1.12"
    set -g fisher_spinners ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏

    function __fisher_show_spinner
        if not set -q __fisher_fg_spinner[1]
            set -g __fisher_fg_spinner $fisher_spinners
        end

        printf "  $__fisher_fg_spinner[1]\r" > /dev/stderr

        set -e __fisher_fg_spinner[1]
    end

    set -l config_home $XDG_CONFIG_HOME
    set -l cache_home $XDG_CACHE_HOME

    if test -z "$config_home"
        set config_home ~/.config
    end

    if test -z "$cache_home"
        set cache_home ~/.cache
    end

    if test -z "$fish_config"
        set -g fish_config "$config_home/fish"
    end

    if test -z "$fisher_config"
        set -g fisher_config "$config_home/fisherman"
    end

    if test -z "$fisher_cache"
        set -g fisher_cache "$cache_home/fisherman"
    end

    if test -z "$fisher_bundle"
        set -g fisher_bundle "$fish_config/fishfile"
    end

    if not command mkdir -p "$fish_config/"{conf.d,functions,completions} "$fisher_config" "$fisher_cache"
        __fisher_log error "
            I couldn't create the fisherman configuration.
            You need write permissions in these directories:

            $fish_config
            $fisher_config
            $fisher_cache
        " > /dev/stderr

        return 1
    end

    set -l completions "$fish_config/completions/fisher.fish"

    if test ! -e "$completions"
        __fisher_completions_write > "$completions"
        source "$completions"
    end

    set -g __fisher_stdout /dev/stdout
    set -g __fisher_stderr /dev/stderr

    for i in -q --quiet
        if set -l index (builtin contains --index -- $i $argv)
            set -e argv[$index]
            set __fisher_stdout /dev/null
            set __fisher_stderr /dev/null

            break
        end
    end

    set -l cmd

    switch "$argv[1]"
        case i install
            set -e argv[1]
            set cmd "install"

        case u up update
            set -e argv[1]
            set cmd "update"

        case r rm remove uninstall
            set -e argv[1]
            set cmd "rm"

        case l ls list
            set -e argv[1]
            set cmd "ls"

        case h help
            set -e argv[1]
            __fisher_help $argv

        case --help
            set -e argv[1]
            __fisher_help

        case -h
            __fisher_usage > /dev/stderr

        case -v --version
            set -l home ~
            printf "fisherman version $fisher_version %s\n" (__fisher_plugin_normalize_path (status -f) | command awk -v home="$home" '{ sub(home, "~") } //')
            return

        case -- ""
            set -e argv[1]

            if test -z "$argv"
                set cmd "default"
            else
                set cmd "install"
            end

        case self-uninstall
            set -e argv[1]
            __fisher_self_uninstall $argv
            return

        case -\*\?
            printf "fisher: '%s' is not a valid option\n" "$argv[1]" > /dev/stderr
            __fisher_usage > /dev/stderr
            return 1

        case \*
            set cmd "install"
    end

    set -l elapsed (__fisher_get_epoch_in_ms)

    set -l items (
        if test ! -z "$argv"
            printf "%s\n" $argv | command awk '

                /^(--|-).*/ { next }

                /^omf\// {
                    sub(/^omf\//, "oh-my-fish/")

                    if ($0 !~ /(theme|plugin)-/) {
                        sub(/^oh-my-fish\//, "oh-my-fish/plugin-")
                    }
                }

                !seen[$0]++

            '
        end
    )

    if test -z "$items" -a "$cmd" = "default"
        if isatty
            touch "$fisher_bundle"

            set items (__fisher_read_bundle_file < "$fisher_bundle")
            set cmd "install"

            if test -z "$items"
                __fisher_usage > /dev/stderr
                return
            end
        end
    end

    switch "$cmd"
        case install
            if __fisher_install $items
                __fisher_log okay "Done in "(__fisher_get_epoch_in_ms $elapsed | __fisher_humanize_duration) $__fisher_stderr
            else
                return
            end

        case update
            if isatty
                if test -z "$items"
                    __fisher_self_update

                    set items (__fisher_list | command sed 's/^[@* ]*//')
                end
            else
                __fisher_parse_column_output | __fisher_read_bundle_file | read -laz _items
                set items $items $_items
            end

            __fisher_update $items

            __fisher_log okay "Done in "(__fisher_get_epoch_in_ms $elapsed | __fisher_humanize_duration) $__fisher_stderr

        case ls
            if test "$argv" -ge 0 -o "$argv" = -
                set items (__fisher_list)

                set -l count (count $items)

                if test "$count" -ge 10
                    printf "%s\n" $items | column -c$argv

                else if test "$count" -ge 1
                    printf "%s\n" $items
                end

            else
                __fisher_list_plugin_directory $argv
            end

        case rm
            if test -z "$items"
                __fisher_parse_column_output | __fisher_read_bundle_file | read -az items
            end

            if test (count $items) -le 1
                function __fisher_show_spinner
                end
            end

            if test ! -z "$items"
                for i in $items
                    set -l name (__fisher_plugin_get_names "$i")[1]
                    __fisher_plugin_disable "$fisher_config/$name"
                    __fisher_show_spinner
                end

                __fisher_log okay "Done in "(__fisher_get_epoch_in_ms $elapsed | __fisher_humanize_duration) $__fisher_stderr
            end
    end

    complete -c fisher --erase

    set -l config $fisher_config/*
    set -l cache $fisher_cache/*

    if test -z "$config"
        echo > $fisher_bundle
    else
        __fisher_plugin_get_url_info -- $config > $fisher_bundle

        complete -xc fisher -n "__fish_seen_subcommand_from u up update r rm remove uninstall" -a "(printf '%s\n' $config | command sed 's|.*/||')"
        complete -xc fisher -n "__fish_seen_subcommand_from u up update r rm remove uninstall" -a "$fisher_active_prompt" -d "Prompt"
    end

    if test ! -z "$cache"
        printf "%s\n" $cache | command awk -v _config="$config" '

            BEGIN {
                count = split(_config, config, " ")
            }

            {
                sub(/.*\//, "")

                for (i = 1; i <= count; i++) {
                    sub(/.*\//, "", config[i])

                    if (config[i] == $0) {
                        next
                    }
                }
            }

            //

        ' | while read -l plugin
            if __fisher_plugin_is_prompt "$fisher_cache/$plugin"
                complete -xc fisher -n "__fish_seen_subcommand_from i in install" -a "$plugin" -d "Prompt"
                complete -xc fisher -n "not __fish_seen_subcommand_from u up update r rm remove uninstall l ls list h help" -a "$plugin" -d "Prompt"
            else
                complete -xc fisher -n "__fish_seen_subcommand_from i in install" -a "$plugin" -d "Plugin"
                complete -xc fisher -n "not __fish_seen_subcommand_from u up update r rm remove uninstall l ls list h help" -a "$plugin" -d "Plugin"
            end
        end
    end
end

function __fisher_install
    if test -z "$argv"
        __fisher_read_bundle_file | read -az argv
    end

    set -e __fisher_fetch_plugins_state

    if set -l fetched (__fisher_plugin_fetch_items (__fisher_plugin_get_missing $argv))
        if test -z "$fetched"
            set -l count (count $argv)

            __fisher_log okay "
                No plugins to install or dependencies missing.
            " $__fisher_stderr

            return 1
        end

        for i in $fetched
            __fisher_plugin_enable "$fisher_config/$i"
        end

    else
        __fisher_log error "
            There was an error cloning @$fetched@ or more plugin/s.
        " $__fisher_stderr

        __fisher_log info "
            Try using a namespace before the plugin name: @omf@/$fetched
        " $__fisher_stderr

        return 1
    end
end


function __fisher_plugin_fetch_items
    __fisher_show_spinner

    set -l jobs
    set -l links
    set -l white
    set -l count (count $argv)

    if test "$count" -eq 0
        return
    end

    switch "$__fisher_fetch_plugins_state"
        case ""
            if test "$count" = 1 -a -d "$argv[1]"
                if test "$argv[1]" = "$PWD"
                    set -l home ~
                    set -l name (printf "%s\n" "$argv[1]" | sed "s|$home|~|")

                    __fisher_log info "Installing @""$name""@ " $__fisher_stderr
                else
                    set -l name (printf "%s\n" "$argv[1]" | sed "s|$PWD/||")

                    __fisher_log info "Installing @""$name""@ " $__fisher_stderr
                end
            else
                __fisher_log info "Installing @$count@ plugin/s" $__fisher_stderr
            end

            set -g __fisher_fetch_plugins_state "fetching"

        case "fetching"
            __fisher_log info "Installing @$count@ dependencies" $__fisher_stderr
            set -g __fisher_fetch_plugins_state "done"

        case "done"
    end

    for i in $argv
        set -l names

        switch "$i"
            case \*gist.github.com\*
                __fisher_log okay "Resolving gist name."
                if not set names (__fisher_get_plugin_name_from_gist "$i") ""
                    __fisher_log error "
                        I couldn't clone your gist:
                        @$i@
                    "
                    continue
                end

            case \*
                set names (__fisher_plugin_get_names "$i")
        end

        if test -d "$i"
            command ln -sf "$i" "$fisher_config/$names[1]"
            set links $links "$names[1]"
            continue
        end

        set -l source "$fisher_cache/$names[1]"

        if test -z "$names[2]"
            if test -d "$source"
                if test -L "$source"
                    command ln -sf "$source" "$fisher_config"
                else
                    command cp -rf "$source" "$fisher_config"
                end
            else
                set jobs $jobs (__fisher_plugin_url_clone_async "$i" "$names[1]")
            end
        else
            if test -d "$source"
                set -l real_namespace (__fisher_plugin_get_url_info --dirname "$source" )

                if test "$real_namespace" = "$names[2]"
                    command cp -rf "$source" "$fisher_config"
                else
                    set jobs $jobs (__fisher_plugin_url_clone_async "$i" "$names[1]")
                end
            else
                set jobs $jobs (__fisher_plugin_url_clone_async "$i" "$names[1]")
            end
        end

        set fetched $fetched "$names[1]"
    end

    __fisher_jobs_await $jobs

    for i in $fetched
        if test ! -d "$fisher_cache/$i"
            printf "%s\n" "$i"
            return 1
        end
    end

    if test ! -z "$fetched"
        __fisher_plugin_fetch_items (__fisher_plugin_get_missing $fetched)
        printf "%s\n" $fetched
    end

    if test ! -z "$links"
        __fisher_plugin_fetch_items (__fisher_plugin_get_missing $links)
        printf "%s\n" $links
    end
end


function __fisher_plugin_url_clone_async -a url name
    switch "$url"
        case https://\*
        case github.com/\*
            set url "https://$url"

        case \?\*/\?\*
            set url "https://github.com/$url"

        case \*
            set url "https://github.com/fisherman/$url"
    end

    set -l nc (set_color normal)
    set -l error (set_color red)
    set -l okay (set_color green)

    set -l hm_url (printf "%s\n" "$url" | sed 's|^https://||')

    fish -c "
            set -lx GIT_ASKPASS /bin/echo

            if command git clone -q --depth 1 '$url' '$fisher_cache/$name' ^ /dev/null
                  printf '$okay""OKAY""$nc Fetching $okay%s$nc %s\n' '$name' '→ $hm_url' > $__fisher_stderr
                  command cp -rf '$fisher_cache/$name' '$fisher_config'
            else
                  printf '$error""ARGH""$nc Fetching $error%s$nc %s\n' '$name' '→ $hm_url' > $__fisher_stderr
            end
      " > /dev/stderr &

    __fisher_jobs_get -l
end


function __fisher_update
    set -l jobs
    set -l count (count $argv)
    set -l updated
    set -l skipped 0

    if test "$count" = 0
        return
    end

    if test "$count" -eq 1
        __fisher_log info "Updating @$count@ plugin" $__fisher_stderr
    else
        __fisher_log info "Updating @$count@ plugins" $__fisher_stderr
    end

    for i in $argv
        set -l path "$fisher_config/$i"

        if test -d "$path"
            set updated $updated "$i"

            if test -L "$fisher_config/$i"
                set skipped (math "$skipped + 1")
                continue
            end

            set jobs $jobs (__fisher_update_path_async "$i" "$path")
        else
            __fisher_log warn "@$i@ is not installed"
        end
    end

    __fisher_jobs_await $jobs

    set -g __fisher_fetch_plugins_state "fetching"
    set -l fetched (__fisher_plugin_fetch_items (__fisher_plugin_get_missing $updated))

    for i in $updated $fetched
        if test "$i" = "$fisher_active_prompt"
            set fisher_active_prompt
        end
        __fisher_plugin_enable "$fisher_config/$i"
    end

    if test "$skipped" -gt 0
        __fisher_log warn "Skipped @$skipped@ symlink/s" $__fisher_stderr
    end
end


function __fisher_self_update
    set -l file (status --current-filename)

    if test "$file" != "$fish_config/functions/fisher.fish"
        return 1
    end

    set -l raw_url "https://raw.githubusercontent.com/fisherman/fisherman/master/fisher.fish"
    set -l fake_qs (date "+%s")

    set -l previous_version "$fisher_version"

    fish -c "curl --max-time 5 -sS '$raw_url?$fake_qs' > $file.$fake_qs" &

    __fisher_jobs_await (__fisher_jobs_get -l)

    if test -s "$file.$fake_qs"
        command mv "$file.$fake_qs" "$file"
    end

    source "$file"
    fisher -v > /dev/null
    set -l new_version "$fisher_version"

    if test "$previous_version" = "$fisher_version"
        __fisher_log okay "fisherman is up to date" $__fisher_stderr
    else
        __fisher_log okay "You are now running fisherman @$fisher_version@" $__fisher_stderr

        __fisher_log info "
            To see the change log, please visit:
            https://github.com/fisherman/fisherman/releases

        " $__fisher_stderr
    end
end


function __fisher_update_path_async -a name path
    set -l nc (set_color normal)
    set -l error (set_color red)
    set -l uline (set_color -u)
    set -l okay (set_color green)

    fish -c "

        pushd $path

        if not command git fetch -q origin master ^ /dev/null
            printf '$error""ARGH""$nc Fetching $error%s$nc\n' '$name' > $__fisher_stderr
            exit
        end

        set -l commits (command git rev-list --left-right --count master..FETCH_HEAD ^ /dev/null | cut -d\t -f2)

        command git reset -q --hard FETCH_HEAD ^ /dev/null
        command git clean -qdfx
        command cp -rf '$path/.' '$fisher_cache/$name'

        if test -z \"\$commits\" -o \"\$commits\" -eq 0
            printf '$okay""OKAY""$nc Latest $okay%s$nc\n' '$name' > $__fisher_stderr
        else
            printf '$okay""OKAY""$nc $okay%s$nc new commits $okay%s$nc\n' \$commits '$name' > $__fisher_stderr
        end

    " > /dev/stderr &

    __fisher_jobs_get -l
end


function __fisher_plugin_enable -a path
    if __fisher_plugin_is_prompt "$path"
        if test ! -z "$fisher_active_prompt"
            __fisher_plugin_disable "$fisher_config/$fisher_active_prompt"
        end

        set -U fisher_active_prompt (basename "$path")
    end

    set -l plugin_name (basename $path)

    for file in $path/{functions/*,}*.fish
        set -l base (basename "$file")

        if test "$base" = "uninstall.fish"
            continue
        end

        switch "$base"
            case {,fish_}key_bindings.fish
                __fisher_key_bindings_append "$plugin_name" "$file"
                continue
        end

        set -l dir "functions"

        if test "$base" = "init.fish"
            set dir "conf.d"

            set base "$plugin_name.$base"
        end

        set -l target "$fish_config/$dir/$base"

        command ln -sf "$file" "$target"

        builtin source "$target"

        if test "$base" = "set_color_custom.fish"
            printf "%s\n" "$fish_color_normal" "$fish_color_command" "$fish_color_param" "$fish_color_redirection" "$fish_color_comment" "$fish_color_error" "$fish_color_escape" "$fish_color_operator" "$fish_color_end" "$fish_color_quote" "$fish_color_autosuggestion" "$fish_color_user" "$fish_color_valid_path" "$fish_color_cwd" "$fish_color_cwd_root" "$fish_color_match" "$fish_color_search_match" "$fish_color_selection" "$fish_pager_color_prefix" "$fish_pager_color_completion" "$fish_pager_color_description" "$fish_pager_color_progress" "$fish_color_history_current" "$fish_color_host" > "$fish_config/fish_colors"
            set_color_custom
        end
    end

    for file in $path/conf.d/*.{py,awk}
        set -l base (basename "$file")
        command ln -sf "$file" "$fish_config/conf.d/$base"
    end

    for file in $path/{functions/,}*.{py,awk}
        set -l base (basename "$file")
        command ln -sf "$file" "$fish_config/functions/$base"
    end

    for file in $path/conf.d/*.fish
        set -l base (basename "$file")
        set -l target "$fish_config/conf.d/$base"

        command ln -sf "$file" "$target"
        builtin source "$target"
    end

    for file in $path/completions/*.fish
        set -l base (basename "$file")
        set -l target "$fish_config/completions/$base"

        command ln -sf "$file" "$target"
        builtin source "$target"
    end

    return 0
end


function __fisher_plugin_disable -a path
    set -l plugin_name (basename $path)

    for file in $path/{functions/*,}*.fish
        set -l name (basename "$file" .fish)
        set -l base "$name.fish"

        if test "$base" = "uninstall.fish"
            builtin source "$file"
            continue
        end

        switch "$base"
            case {,fish_}key_bindings.fish
                __fisher_key_bindings_remove "$plugin_name"
                continue
        end

        set -l dir "functions"

        if test "$base" = "init.fish"
            set dir "conf.d"
            set base "$plugin_name.$base"
        end

        command rm -f "$fish_config/$dir/$base"

        functions -e "$name"

        if test "$base" = "set_color_custom.fish"
            set -l fish_colors_config "$fish_config/fish_colors"

            if test ! -f "$fish_colors_config"
                __fisher_reset_default_fish_colors
                continue
            end

            set -l IFS \n

            read -laz colors < $fish_colors_config
            set colors[25] ""

            set -l IFS " "

            echo "$colors[1]" | read -a -U fish_color_normal
            echo "$colors[2]" | read -a -U fish_color_command
            echo "$colors[3]" | read -a -U fish_color_param
            echo "$colors[4]" | read -a -U fish_color_redirection
            echo "$colors[5]" | read -a -U fish_color_comment
            echo "$colors[6]" | read -a -U fish_color_error
            echo "$colors[7]" | read -a -U fish_color_escape
            echo "$colors[8]" | read -a -U fish_color_operator
            echo "$colors[9]" | read -a -U fish_color_end
            echo "$colors[10]" | read -a -U fish_color_quote
            echo "$colors[11]" | read -a -U fish_color_autosuggestion
            echo "$colors[12]" | read -a -U fish_color_user
            echo "$colors[13]" | read -a -U fish_color_valid_path
            echo "$colors[14]" | read -a -U fish_color_cwd
            echo "$colors[15]" | read -a -U fish_color_cwd_root
            echo "$colors[16]" | read -a -U fish_color_match
            echo "$colors[17]" | read -a -U fish_color_search_match
            echo "$colors[18]" | read -a -U fish_color_selection
            echo "$colors[19]" | read -a -U fish_pager_color_prefix
            echo "$colors[20]" | read -a -U fish_pager_color_completion
            echo "$colors[21]" | read -a -U fish_pager_color_description
            echo "$colors[22]" | read -a -U fish_pager_color_progress
            echo "$colors[23]" | read -a -U fish_color_history_current
            echo "$colors[24]" | read -a -U fish_color_host

            command rm -f $fish_colors_config
        end
    end

    for file in $path/conf.d/*.{py,awk}
        set -l base (basename "$file")
        command rm -f "$fish_config/conf.d/$base"
    end

    for file in $path/{functions/,}*.{py,awk}
        set -l base (basename "$file")
        command rm -f "$fish_config/functions/$base"
    end

    for file in $path/conf.d/*.fish
        set -l base (basename "$file")
        command rm -f "$fish_config/conf.d/$base"
    end

    for file in $path/completions/*.fish
        set -l name (basename "$file" .fish)
        set -l base "$name.fish"

        command rm -f "$fish_config/completions/$base"
        complete -c "$name" --erase
    end

    if __fisher_plugin_is_prompt "$path"
        set -U fisher_active_prompt
        builtin source $__fish_datadir/functions/fish_prompt.fish ^ /dev/null
    end

    command rm -rf "$path" > /dev/stderr
end


function __fisher_get_plugin_name_from_gist -a url
    set -l gist_id (printf "%s\n" "$url" | command sed 's|.*/||')
    set -l name (fish -c "

        fisher -v > /dev/null
        curl -Ss https://api.github.com/gists/$gist_id &

        __fisher_jobs_await (__fisher_jobs_get -l)

    " | command awk '

        /"files": / {
            files++
        }

        /"[^ ]+.fish": / && files {
            gsub("^ *\"|\.fish.*", "")
            print
        }

    ')

    if test -z "$name"
        return 1
    end

    printf "%s\n" $name
end


function __fisher_list
    set -l config $fisher_config/*

    if test -z "$config"
        return 1
    end

    set -l white
    set -l links (command find $config -maxdepth 0 -type l ! -name "$fisher_active_prompt" ^ /dev/null)
    set -l names (command find $config -maxdepth 0 -type d ! -name "$fisher_active_prompt" ^ /dev/null)

    if test ! -z "$links"
        set white "  "
        printf "%s\n" $links | command sed "s|.*/|@ |"
    end

    if test ! -z "$fisher_active_prompt"
        set white "  "
        printf "* %s\n" "$fisher_active_prompt"
    end

    if test ! -z "$names"
        printf "%s\n" $names | command sed "s|.*/|$white|"
    end
end


function __fisher_list_plugin_directory -a item
    set -l fd $__fisher_stderr

    set -e argv[1]
    set -l path "$fisher_config/$item"

    if test ! -d "$path"
        __fisher_log error "$item is not installed" $__fisher_stderr

        return 1
    end

    pushd "$path"

    set -l color (set_color $fish_color_command)
    set -l nc (set_color normal)
    set -l previous_tree

    if contains -- --no-color $argv
        set color
        set nc
        set fd $__fisher_stdout
    end

    printf "$color%s$nc\n" "$PWD" > $fd

    for file in .* **
        if test -f "$file"
            switch "$file"
                case \*/\*
                    set -l current_tree (dirname $file)

                    if test "$previous_tree" != "$current_tree"
                        printf "    $color%s/$nc\n" $current_tree
                    end

                    printf "        %s\n" (basename $file)

                    set previous_tree $current_tree

                case \*
                    printf "    %s\n" $file
            end
        end
    end > $fd

    popd
end


function __fisher_log -a log message fd
    set -l nc (set_color normal)
    set -l okay (set_color green)
    set -l info (set_color green)
    set -l warn (set_color yellow)
    set -l error (set_color red)

    switch "$fd"
        case "/dev/null"
            return

        case "" "/dev/stderr"
            set fd "/dev/stderr"

        case \*
            set nc ""
            set okay ""
            set info ""
            set warn ""
            set error ""
    end

    printf "%s\n" "$message" | command awk '
        function okay(s) {
            printf("'$okay'%s'$nc' %s\n", "OKAY", s)
        }

        function info(s) {
            printf("'$info'%s'$nc' %s\n", "INFO", s)
        }

        function warn(s) {
            printf("'$warn'%s'$nc' %s\n", "WARN", s)
        }

        function error(s) {
            printf("'$error'%s'$nc' %s\n", "ARGH", s)
        }

        {
            sub(/^[ ]+/, "")
            gsub("``", "  ")

            if (/@[^@]+@/) {
                n = match($0, /@[^@]+@/)
                if (n) {
                    sub(/@[^@]+@/, "'"$$log"'" substr($0, RSTART + 1, RLENGTH - 2) "'$nc'", $0)
                }
            }

            s[++len] = $0
        }

        END {
            for (i = 1; i <= len; i++) {
                if ((i == 1 || i == len) && (s[i] == "")) {
                    continue
                }

                if (s[i] == "") {
                    print
                } else {
                    '$log'(s[i])
                }
            }
        }

    ' > "$fd"
end


function __fisher_jobs_get
    jobs $argv | command awk -v FS=\t '
        /[0-9]+\t/{
            jobs[++job_count] = $1
        }

        END {
            for (i = 1; i <= job_count; i++) {
                print(jobs[i])
            }

            exit job_count == 0
        }
    '
end


function __fisher_jobs_await
    if test -z "$argv"
        return
    end

    while true
        for spinner in $fisher_spinners
            printf "  $spinner  \r" > /dev/stderr
            sleep 0.04
        end

        set -l currently_active_jobs (__fisher_jobs_get)

        if test -z "$currently_active_jobs"
            break
        end

        set -l has_jobs

        for i in $argv
            if builtin contains -- $i $currently_active_jobs
                set has_jobs "*"
                break
            end
        end

        if test -z "$has_jobs"
            break
        end
    end
end


function __fisher_key_bindings_remove -a plugin_name
    set -l user_key_bindings "$fish_config/functions/fish_user_key_bindings.fish"
    set -l tmp (date "+%s")

    fish_indent < "$user_key_bindings" | sed -n "/### $plugin_name ###/,/### $plugin_name ###/{s/^ *bind /bind -e /p;};" | source ^ /dev/null

    sed "/### $plugin_name ###/,/### $plugin_name ###/d" < "$user_key_bindings" > "$user_key_bindings.$tmp"
    command mv -f "$user_key_bindings.$tmp" "$user_key_bindings"

    if awk '
        /^$/ { next }

        /^function fish_user_key_bindings/ {
            i++
            next
        }

        /^end$/ && 1 == i {
            exit 0
        }

        // {
            exit 1
        }

    ' < "$user_key_bindings"

        command rm -f "$user_key_bindings"
    end
end


function __fisher_key_bindings_append -a plugin_name file
    set -l user_key_bindings "$fish_config/functions/fish_user_key_bindings.fish"

    command mkdir -p (dirname "$user_key_bindings")
    touch "$user_key_bindings"

    set -l key_bindings_source (
        fish_indent < "$user_key_bindings" | awk '

            /^function fish_user_key_bindings/ {
                reading_function_source = 1
                next
            }

            /^end$/ {
                exit
            }

            reading_function_source {
                print $0
                next
            }

        '
    )

    set -l plugin_key_bindings_source (
        fish_indent < "$file" | awk -v name="$plugin_name" '

            BEGIN {
                printf("### %s ###\n", name)
            }

            END {
                printf("### %s ###\n", name)
            }

            /^function fish_user_key_bindings$/ {
                check_for_and_keyword = 1
                next
            }

            /^end$/ && check_for_and_keyword {
                end = 0
                next
            }

            !/^ *(#.*)*$/ {
                gsub("#.*", "")
                printf("%s\n", $0)
            }

        '
    )

    printf "%s\n" $key_bindings_source $plugin_key_bindings_source | awk '

        BEGIN {
            print "function fish_user_key_bindings"
        }

        //

        END {
            print "end"
        }

    ' | fish_indent > "$user_key_bindings"
end


function __fisher_plugin_is_prompt -a path
    if test -e $path/fish_prompt.fish
        return
    end

    if test -e $path/functions/fish_prompt.fish
        return
    end

    if test -e $path/fish_right_prompt.fish
        return
    end

    if test -e $path/functions/fish_right_prompt.fish
        return
    end

    return 1
end


function __fisher_plugin_get_names
    printf "%s\n" $argv | command awk '

        {
            sub(/\/$/, "")
            n = split($0, s, "/")
            sub(/^(omf|omf-theme|omf-plugin|plugin|theme|fish|fisher)-/, "", s[n])

            printf("%s\n%s\n", s[n], s[n - 1])
        }

    '
end


function __fisher_plugin_get_url_info -a option
    set -e argv[1]

    if test -z "$argv"
        return
    end

    cat {$argv}/.git/config ^ /dev/null | command awk -v option="$option" '
        /url/ {
            n = split($3, s, "/")

            if ($3 ~ /https:\/\/gist/) {
                printf("# %s\n", $3)
                next
            }

            if (option == "--dirname") {
                printf("%s\n", s[n - 1])

            } else if (option == "--basename") {
                printf("%s\n", s[n])

            } else {
                printf("%s/%s\n", s[n - 1], s[n])
            }
        }
    '
end


function __fisher_plugin_normalize_path
    printf "%s\n" $argv | command awk -v pwd="$PWD" '

        /^\.$/ {
            print(pwd)
            next
        }

        /^\// {
            sub(/\/$/, "")
            print($0)
            next
        }

        {
            print(pwd "/" $0)
            next
        }

    '
end


function __fisher_plugin_get_missing
    for i in $argv
        if test -d "$i"
            set i (__fisher_plugin_normalize_path "$i")
        end

        set -l name (__fisher_plugin_get_names "$i")[1]

        if set -l path (__fisher_plugin_is_installed "$name")
            for file in fishfile bundle
                if test -s "$path/$file"
                    __fisher_plugin_get_missing (__fisher_read_bundle_file < "$path/$file")
                end
            end
        else
            printf "%s\n" "$i"
        end
    end

    __fisher_show_spinner
end


function __fisher_plugin_is_installed -a name
    if test -z "$name" -o ! -d "$fisher_config/$name"
        return 1
    end

    printf "%s\n" "$fisher_config/$name"
end


function __fisher_reset_default_fish_colors
    set -U fish_color_normal normal
    set -U fish_color_command 005fd7 purple
    set -U fish_color_param 00afff cyan
    set -U fish_color_redirection 005fd7
    set -U fish_color_comment 600
    set -U fish_color_error red --bold
    set -U fish_color_escape cyan
    set -U fish_color_operator cyan
    set -U fish_color_end green
    set -U fish_color_quote brown
    set -U fish_color_autosuggestion 555 yellow
    set -U fish_color_user green
    set -U fish_color_valid_path --underline
    set -U fish_color_cwd green
    set -U fish_color_cwd_root red
    set -U fish_color_match cyan
    set -U fish_color_search_match --background=purple
    set -U fish_color_selection --background=purple
    set -U fish_pager_color_prefix cyan
    set -U fish_pager_color_completion normal
    set -U fish_pager_color_description 555 yellow
    set -U fish_pager_color_progress cyan
    set -U fish_color_history_current cyan
    set -U fish_color_host normal
end


function __fisher_read_bundle_file
    command awk -v FS=\t '
        /^$/ || /^[ \t]*#/ {
            next
        }

        /^[ \t]*package / {
            sub("^[ \t]*package ", "oh-my-fish/plugin-")
        }

        {
            sub("^[@* \t]*", "")

            if (!seen[$0]++) {
                printf("%s\n", $0)
            }
        }
    '
end


function __fisher_completions_write
    functions __fisher_completions_write | fish_indent | __fisher_parse_comments_from_function

    # complete -xc fisher -s h -l help -d "Show usage help"
    # complete -xc fisher -s q -l quiet -d "Enable quiet mode"
    # complete -xc fisher -s v -l version -d "Show version information"
    # complete -xc fisher -n "__fish_use_subcommand" -a install -d "Install plugins  /  i"
    # complete -xc fisher -n "__fish_use_subcommand" -a update -d "Update itself and plugins  /  u"
    # complete -xc fisher -n "__fish_use_subcommand" -a rm -d "Remove plugins  /  r"
    # complete -xc fisher -n "__fish_use_subcommand" -a ls -d "List plugins  /  l"
    # complete -xc fisher -n "__fish_use_subcommand" -a help -d "Show help  /  h"
end


function __fisher_humanize_duration
    awk '
        function hmTime(time,   stamp) {
            split("h:m:s:ms", units, ":")

            for (i = 2; i >= -1; i--) {
                if (t = int( i < 0 ? time % 1000 : time / (60 ^ i * 1000) % 60 )) {
                    stamp = stamp t units[sqrt((i - 2) ^ 2) + 1] " "
                }
            }

            if (stamp ~ /^ *$/) {
                return "0ms"
            }

            return substr(stamp, 1, length(stamp) - 1)
        }

        {
            print hmTime($0)
        }
    '
end


function __fisher_get_key
    stty -icanon -echo ^ /dev/null

    printf "$argv" > /dev/stderr

    while true
        dd bs=1 count=1 ^ /dev/null | read -p "" -l yn

        switch "$yn"
            case y Y n N
                printf "\n" > /dev/stderr
                printf "%s\n" $yn > /dev/stdout
                break
        end
    end

    stty icanon echo > /dev/stderr ^ /dev/null
end


function __fisher_get_epoch_in_ms -a elapsed
    if test -z "$elapsed"
        set elapsed 0
    end

    perl -MTime::HiRes -e 'printf("%.0f\n", (Time::HiRes::time() * 1000) - '$elapsed')'
end


function __fisher_parse_column_output
    command awk -v FS=\t '
        {

            for (i = 1; i <= NF; i++) {
                if ($i != "") {
                    print $i
                }
            }

        }
    '
end


function __fisher_parse_comments_from_function
    command awk '

        /^[\t ]*# ?/ {
            sub(/^[\t ]*# ?/, "")
            a[++n] = $0
        }

        END {
            for (i = 1; i <= n; i++) {
                printf("%s\n", a[i])
            }
        }

    '
end


function __fisher_usage
    set -l u (set_color -u)
    set -l nc (set_color normal)

    echo "Usage: fisher [<command>] [<plugins>] [--quiet] [--version]"
    echo
    echo "where <command> can be one of:"
    echo "       "$u"i"$nc"nstall (default)"
    echo "       "$u"u"$nc"pdate"
    echo "       "$u"r"$nc"m"
    echo "       "$u"l"$nc"s"
    echo "       "$u"h"$nc"elp"
end


function __fisher_help -a cmd number
    if test -z "$argv"
        set -l page "$fisher_cache/fisher.1"

        if test ! -s "$page"
            __fisher_man_page_write > "$page"
        end

        set -l pager "/usr/bin/less -s"

        if test ! -z "$PAGER"
            set pager "$PAGER"
        end

        man -P "$pager" -- "$page"

        command rm -f "$page"

    else
        if test -z "$number"
            set number 1
        end

        set -l page "$fisher_config/$cmd/man/man$number/$cmd.$number"

        if not man "$page" ^ /dev/null
            __fisher_log error "No manual entry for $cmd" $__fisher_stderr

            if test -d "$fisher_config/$cmd"
                set -l url (__fisher_plugin_get_url_info -- $fisher_config/$cmd)

                if test ! -z "$url"
                    __fisher_log info "Visit the online repository for help:" $__fisher_stderr
                    __fisher_log info "@https://github.com/$url@" $__fisher_stderr
                end
            else
                __fisher_log error "$cmd is not installed" $__fisher_stderr
            end

            return 1
        end
    end
end


function __fisher_self_uninstall -a yn
    set -l file (status --current-filename)

    if test -z "$fish_config" -o -z "$fisher_cache" -o -z "$fisher_config" -o -L "$fisher_cache" -o -L "$fisher_config" -o "$file" != "$fish_config/functions/fisher.fish"
        __fisher_log warn "Global or non-standard setup detected."
        __fisher_log says "Use your package manager to remove fisherman." /dev/stderr

        return 1
    end

    set -l u (set_color -u)
    set -l nc (set_color normal)

    switch "$yn"
        case -y --yes
        case \*
            __fisher_log warn "
                This will permanently remove fisherman from your system.
                The following directories and files will be erased:

                $fisher_cache
                $fisher_config
                $fish_config/functions/fisher.fish
                $fish_config/completions/fisher.fish

            " /dev/stderr

            echo -sn "Do you wish to continue? [Y/n] " > /dev/stderr

            __fisher_get_key | read -l yn

            switch "$yn"
                case n N
                    set -l username

                    if test ! -z "$USER"
                        set username " $USER"
                    end

                    __fisher_log okay "As you wish cap!"
                    return 1
            end
    end

    complete -c fisher --erase

    __fisher_show_spinner

    fisher ls | fisher rm

    __fisher_show_spinner

    command rm -rf "$fisher_cache" "$fisher_config"
    command rm -f "$fish_config"/{functions,completions}/fisher.fish "$fisher_bundle"

    __fisher_show_spinner

    set -e fisher_active_prompt
    set -e fisher_cache
    set -e fisher_config
    set -e fish_config
    set -e fisher_bundle
    set -e fisher_version
    set -e fisher_spinners

    for func in __fisher_jobs_await __fisher_plugin_url_clone_async __fisher_completions_write __fisher_plugin_fetch_items __fisher_get_epoch_in_ms __fisher_jobs_get __fisher_get_key __fisher_get_plugin_name_from_gist __fisher_plugin_get_names __fisher_plugin_get_url_info __fisher_plugin_get_missing __fisher_help __fisher_humanize_duration __fisher_install __fisher_list __fisher_list_plugin_directory __fisher_man_page_write __fisher_plugin_normalize_path __fisher_parse_column_output __fisher_parse_comments_from_function __fisher_plugin_is_prompt __fisher_plugin_disable __fisher_plugin_enable __fisher_plugin_is_installed __fisher_read_bundle_file __fisher_reset_default_fish_colors __fisher_self_uninstall __fisher_self_update __fisher_usage __fisher_update __fisher_update_path_async
        __fisher_show_spinner
        functions -e "$func"
    end

    __fisher_show_spinner

    functions -e __fisher_show_spinner

    __fisher_log okay "Arrr! So long and thanks for all the fish." $__fisher_stderr

    functions -e __fisher_log
    functions -e fisher
end


function __fisher_man_page_write
    functions __fisher_man_page_write | fish_indent | __fisher_parse_comments_from_function

    # .
    # .TH "FISHERMAN" "1" "April 2016" "" "fisherman"
    # .
    # .SH "NAME"
    # \fBfisherman\fR \- fish shell plugin manager
    # .
    # .SH "SYNOPSIS"
    # fisher [\fIcommand\fR] [\fIplugins\fR] [\-\-quiet] [\-\-version]
    # .
    # .br
    # .
    # .P
    # where \fIcommand\fR can be one of: \fBi\fRnstall, \fBu\fRpdate, \fBls\fR, \fBrm\fR and \fBh\fRelp
    # .
    # .SH "USAGE"
    # Install a plugin\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher simple
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Install from multiple sources\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher z fzf omf/{grc,thefuck}
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Install from a url\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher https://github\.com/edc/bass
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Install from a gist\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher https://gist\.github\.com/username/1f40e1c6e0551b2666b2
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Install from a local directory\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher ~/my_aliases
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Use it a la vundle\. Edit your fishfile and run \fBfisher\fR to satisfy changes\.
    # .
    # .P
    # See \fIFAQ\fR#What is a fishfile and how do I use it?
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # $EDITOR fishfile # add plugins
    # fisher
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # See what\'s installed\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher ls
    # @ my_aliases    # this plugin is a local directory
    # * simple        # this plugin is the current prompt
    #   bass
    #   fzf
    #   grc
    #   thefuck
    #   z
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Update everything\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher up
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Update some plugins\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher up bass z fzf thefuck
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Remove plugins\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher rm simple
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Remove all the plugins\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher ls | fisher rm
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # Get help\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher help z
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .SH "OPTIONS"
    # .
    # .IP "\(bu" 4
    # \-v, \-\-version Show version information\.
    # .
    # .IP "\(bu" 4
    # \-h, \-\-help Show usage help\. Use the long form to display this page instead\.
    # .
    # .IP "\(bu" 4
    # \-q, \-\-quiet Enable quiet mode\. Use to suppress output\.
    # .
    # .IP "" 0
    # .
    # .SH "FAQ"
    # .
    # .SS "1\. What is the required fish version?"
    # fisherman was built for fish >= 2\.3\.0\. If you are using 2\.2\.0, append the following code to your \fB~/\.config/fish/config\.fish\fR for snippet support\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # for file in ~/\.config/fish/conf\.d/*\.fish
    #     source $file
    # end
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .SS "2\. How do I use fish as my default shell?"
    # Add fish to the list of login shells in \fB/etc/shells\fR and make it your default shell\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # echo "/usr/local/bin/fish" | sudo tee \-a /etc/shells
    # chsh \-s /usr/local/bin/fish
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .SS "3\. How do I uninstall fisherman?"
    # Run
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisher self\-uninstall
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .SS "4\. Is fisherman compatible with oh my fish themes and plugins?"
    # Yes\.
    # .
    # .SS "5\. Where does fisherman put stuff?"
    # fisherman goes in \fB~/\.config/fish/functions/fisher\.fish\fR\.
    # .
    # .P
    # The cache and plugin configuration is created in \fB~/\.cache/fisherman\fR and \fB~/\.config/fisherman\fR respectively\.
    # .
    # .P
    # The fishfile is saved to \fB~/\.config/fish/fishfile\fR\.
    # .
    # .SS "6\. What is a fishfile and how do I use it?"
    # The fishfile \fB~/\.config/fish/fishfile\fR lists all the installed plugins\.
    # .
    # .P
    # You can let fisherman take care of this file for you automatically, or write in the plugins you want and run \fBfisher\fR to satisfy the changes\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # fisherman/simple
    # fisherman/z
    # omf/thefuck
    # omf/grc
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .P
    # This mechanism only installs plugins and missing dependencies\. To remove a plugin, use \fBfisher rm\fR instead\.
    # .
    # .SS "6\. Where can I find a list of fish plugins?"
    # Browse \fIhttps://github\.com/fisherman\fR or use \fIhttp://fisherman\.sh/#search\fR to discover content\.
    # .
    # .SS "7\. What is a plugin?"
    # A plugin is:
    # .
    # .IP "1." 4
    # a directory or git repo with a function \fB\.fish\fR file either at the root level of the project or inside a \fBfunctions\fR directory
    # .
    # .IP "2." 4
    # a theme or prompt, i\.e, a \fBfish_prompt\.fish\fR, \fBfish_right_prompt\.fish\fR or both files
    # .
    # .IP "3." 4
    # a snippet, i\.e, one or more \fB\.fish\fR files inside a directory named \fBconf\.d\fR that are evaluated by fish at the start of the shell
    # .
    # .IP "" 0
    # .
    # .SS "8\. How can I list plugins as dependencies to my plugin?"
    # Create a new \fBfishfile\fR file at the root level of your project and write in the plugin dependencies\.
    # .
    # .IP "" 4
    # .
    # .nf
    #
    # owner/repo
    # https://github\.com/dude/sweet
    # https://gist\.github\.com/bucaran/c256586044fea832e62f02bc6f6daf32
    # .
    # .fi
    # .
    # .IP "" 0
    # .
    # .SS "9\. I have a question or request not addressed here\. Where should I put it?"
    # Create a new ticket on the issue tracker:
    # .
    # .IP "\(bu" 4
    # \fIhttps://github\.com/fisherman/fisherman/issues\fR
    # .
    # .IP "" 0
end
