if not set -q fisher_cmd_name
    status --current-filename | command awk '
        {
            if (n = split($0, parts, "/")) {
                gsub(/\.fish$/, "", parts[n])
                print(parts[n])
            }
        }
    ' | read -gx fisher_cmd_name
end

if test -z "$fisher_cmd_name"
    set -gx fisher_cmd_name "fisher"
end

function $fisher_cmd_name -d "fish plugin manager"
    switch "$FISH_VERSION"
        case 2.1.2 2.1.1 2.1.0 2.0.0
            echo "You need fish 2.2.0 or higher to use fisherman."

            if type brew >/dev/null 2>&1
                echo "Run: brew upgrade fish"
            else
                echo "
                    Refer to your package manager documentation for
                    instructions on how to upgrade your fish build.
                "
            end

            return 1

        case 2.2.0
            __fisher_log info "
                You need fish 2.3.0 or higher to take advantage of snippets.
                Without it some plugins might not work.
            "

            if type -q brew
                __fisher_log info "Please run &brew upgrade fish&"
            else
                __fisher_log info "

                    Refer to your package manager documentation
                    for instructions on how to upgrade your fish build.

                    If you can not upgrade, append the following code
                    to your ~/.config/fish/config.fish:

                    &for file in ~/.config/fish/conf.d/*.fish&
                    	&source \$file&
                    &end&

                "
            end
    end

    set -g fisher_version "2.13.2"
    set -g fisher_spinners ⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏

    if [ -e /dev/stdout ]
      set -g __fisher_stdout /dev/stdout
    else if [ -e /proc/self/fd/1 ]
      set -g __fisher_stdout /proc/self/fd/1
    else
      echo "No suitable stdout"
      return 1
    end

    if [ -e /dev/stderr ]
      set -g __fisher_stderr /dev/stderr
    else if [ -e /proc/self/fd/2 ]
      set -g __fisher_stderr /proc/self/fd/2
    else
      echo "No suitable stderr"
      return 1
    end

    function __fisher_show_spinner
        if not set -q __fisher_fg_spinner[1]
            set -g __fisher_fg_spinner $fisher_spinners
        end

        printf "  $__fisher_fg_spinner[1]\r" >&2

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

    if test -z "$fish_path"
        set -g fish_path "$fish_config"
    end

    if test -z "$fisher_file"
        set -g fisher_file "$fish_path/fishfile"
    end

    switch "$argv[1]"
        case --complete
            __fisher_complete
            return

        case -v --version
            __fisher_version
            return

        case -h
            __fisher_usage >&2
            return
    end

    command mkdir -p {"$fish_path","$fish_config"}/{conf.d,functions,completions} "$fisher_config" "$fisher_cache"
    or return 1

    set -l completions "$fish_path/completions/$fisher_cmd_name.fish"

    if test ! -e "$completions"
        echo "$fisher_cmd_name --complete" > "$completions"
        __fisher_complete
    end

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

            if test -z "$argv"
                set cmd "default"
            else
                set cmd "install"
            end

        case u up update
            set -e argv[1]
            set cmd "update"

        case r rm remove uninstall
            set -e argv[1]
            set cmd "rm"

        case l ls list
            set -e argv[1]
            set cmd "ls"

        case info ls-remote
            set -e argv[1]
            set cmd "ls-remote"

        case h help
            set -e argv[1]
            __fisher_help $argv
            return

        case --help
            set -e argv[1]
            __fisher_help
            return

        case -- ""
            set -e argv[1]

            if test -z "$argv"
                set cmd "default"
            else
                set cmd "install"
            end

        case self-{uninstall,destroy}
            set -e argv[1]
            __fisher_self_uninstall $argv
            return

        case -\*\?
            printf "$fisher_cmd_name: '%s' is not a valid option\n" "$argv[1]" >&2
            __fisher_usage >&2
            return 1

        case \*
            set cmd "install"
    end

    set -l elapsed (__fisher_get_epoch_in_ms)
    set -l items (
        if test ! -z "$argv"
            printf "%s\n" $argv | __fisher_read_bundle_file
        end
    )

    if test -z "$items" -a "$cmd" = "default"
        if isatty
            command touch "$fisher_file"

            set cmd "install"
            set items (__fisher_read_bundle_file < "$fisher_file")

            if test -z "$items"
                __fisher_log info "
                    No plugins to install or dependencies missing.
                " >&2

                __fisher_log info "
                    See &$fisher_cmd_name help& for usage instructions.
                " >&2
                return
            end
        else
            set cmd "install"
        end
    end

    switch "$cmd"
        case install update
            if not command -s git > /dev/null
                __fisher_log error "
                    git is required to download plugin repositories.
                " >&2

                __fisher_log info "
                    Please install git and try again.
                    Visit <&https://git-scm.com&> for more information.
                " >&2

                return 1
            end

        case ls ls-remote
            if not command -s curl > /dev/null
                __fisher_log error "
                    curl is required to query the GitHub API.
                " >&2

                __fisher_log info "
                    Please install curl and try again.
                    Refer to your package manager documentation for instructions.
                " >&2

                return 1
            end
    end

    switch "$cmd"
        case install
            if __fisher_install $items
                __fisher_log info "Done in &"(__fisher_get_epoch_in_ms $elapsed | __fisher_humanize_duration)"&" "$__fisher_stderr"
            end

        case update
            if isatty
                if test -z "$items"
                    set items (__fisher_list | command sed 's/^[@* ]*//')

                    if not __fisher_self_update
                        if test -z "$items"
                            __fisher_log info "Use your package manager to update fisherman."
                            return 1
                        end
                    end
                end
            else
                __fisher_parse_column_output | __fisher_read_bundle_file | read -laz _items
                set items $items $_items
            end

            __fisher_update $items

            __fisher_log info "Done in &"(__fisher_get_epoch_in_ms $elapsed | __fisher_humanize_duration)"&" "$__fisher_stderr"

        case ls
            if test (count "$argv") -ge 0 -o "$argv" = -
                if isatty stdout
                    __fisher_list | column -c$argv
                else
                    __fisher_list | sed 's|^[@* ]*||'
                end

            else
                __fisher_list_plugin_directory $argv
            end

        case ls-remote
            set -l format

            if test ! -z "$argv"
                switch "$argv[1]"
                    case --format\*
                        set format (printf "%s\n" "$argv[1]" | command sed 's|^--[^= ]*[= ]\(.*\)|\1|')
                        set -e argv[1]
                end

                if test -z "$format"
                    set format "%info\n%url\n"
                end
            end

            if test -z "$format"
                set format "%name\n"

                if isatty stdout
                    __fisher_list_remote "$format" $argv | column
                else
                    __fisher_list_remote "$format" $argv
                end
            else
                __fisher_list_remote "$format" $argv
            end

        case rm
            if test -z "$items"
                __fisher_parse_column_output | __fisher_read_bundle_file | read -az items
            end

            for i in $items
                set -l name (__fisher_plugin_get_names $i)[1]

                if test ! -d "$fisher_config/$name"
                    set -e items

                    if test -L "$fisher_config/$name"
                        set -l real_path (command readlink "$fisher_config/$name")

                        __fisher_log error "
                            I can't remove &$name& without its real path.
                        " "$__fisher_stderr"

                        __fisher_log info "
                            Restore &$real_path& and try again.
                        " "$__fisher_stderr"
                    else
                        __fisher_log error "Plugin &$name& is not installed." "$__fisher_stderr"
                    end

                    break
                end
            end

            if test ! -z "$items"
                __fisher_remove $items
                __fisher_log info "Done in &"(
                    __fisher_get_epoch_in_ms $elapsed | __fisher_humanize_duration)"&" "$__fisher_stderr"
            end
    end

    set -l config_glob $fisher_config/*
    set -l config (
        if test ! -z "$config_glob"
            command find $config_glob -maxdepth 0 -type d | command sed "s|.*/||"
        end
    )

    switch "$cmd"
        case ls ls-remote
        case \*
            if test -z "$config"
                echo > "$fisher_file"
                set -e fisher_dependency_count
            else
                __fisher_plugin_get_url_info -- "$fisher_config"/$config > $fisher_file
            end
    end

    complete -c $fisher_cmd_name --erase

    __fisher_complete
end


function __fisher_install
    if test -z "$argv"
        __fisher_read_bundle_file | read -az argv
    end

    set -e __fisher_fetch_plugins_state

    if set -l fetched (__fisher_plugin_fetch_items (__fisher_plugin_get_missing $argv))
        if test -z "$fetched"
            __fisher_log info "
                No plugins to install or dependencies missing.
            " "$__fisher_stderr"

            return 1
        end

        for i in $fetched
            __fisher_show_spinner

            if test -f "$fisher_config/$i/fishfile"
                while read -l i
                    set -l name (__fisher_plugin_get_names "$i")[1]

                    if contains -- "$name" $fetched
                        if contains -- "$name" $argv
                            __fisher_plugin_increment_ref_count "$name"
                        end
                    else
                        __fisher_plugin_increment_ref_count "$name"
                    end

                end < "$fisher_config/$i/fishfile"
            end

            __fisher_show_spinner
            __fisher_plugin_increment_ref_count "$i"

            set -l path "$fisher_config/$i"

            if __fisher_plugin_is_prompt "$path"
                if test ! -z "$fisher_active_prompt"
                    __fisher_remove "$fisher_active_prompt"
                end

                set -U fisher_active_prompt "$i"
            end

            __fisher_plugin_enable "$path"
        end
    else
        __fisher_log error "
            There was an error installing &$fetched& or more plugin/s.
        " "$__fisher_stderr"

        __fisher_log info "
            Try using a namespace before the plugin name: &owner&/$fetched
        " "$__fisher_stderr"

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
                    set -l name (printf "%s\n" "$argv[1]" | command sed "s|$home|~|")

                    __fisher_log info "Installing &$name& " "$__fisher_stderr"
                else
                    set -l name (printf "%s\n" "$argv[1]" | command sed "s|$PWD/||")

                    __fisher_log info "Installing &$name& " "$__fisher_stderr"
                end
            else
                __fisher_log info "Installing &$count& plugin/s" "$__fisher_stderr"
            end

            set -g __fisher_fetch_plugins_state "fetching"

        case "fetching"
            if test "$count" -eq 1
                __fisher_log info "Installing &1& dependency" "$__fisher_stderr"
            else
                __fisher_log info "Installing &$count& dependencies" "$__fisher_stderr"
            end

            set -g __fisher_fetch_plugins_state "done"

        case "done"
    end

    for i in $argv
        set -l names
        set -l branch

        switch "$i"
            case \*gist.github.com\*
                __fisher_log okay "Resolving gist name."
                if not set names (__fisher_get_plugin_name_from_gist "$i") ""
                    __fisher_log error "
                        I couldn't clone this gist:
                        &$i&
                    "
                    continue
                end

            case \*
                printf "%s\n" "$i" | sed 's/[@:]\(.*\)/ \1/' | read i branch
                set names (__fisher_plugin_get_names "$i")
        end

        if test -d "$i"
            command ln -sf "$i" "$fisher_config/$names[1]"
            set links $links "$names[1]"
            continue
        end

        set -l src "$fisher_cache/$names[1]"

        if test -z "$names[2]"
            if test -d "$src" -a -z "$branch"
                if test ! -d "$fisher_config/$names[1]"
                    __fisher_log okay "Copy &$names[1]&" "$__fisher_stderr"
                end

                if test -L "$src"
                    command ln -sf "$src" "$fisher_config"
                else
                    command cp -Rf "$src" "$fisher_config"
                end
            else
                set jobs $jobs (__fisher_plugin_url_clone_async "$i" "$names[1]" "$branch")
            end
        else
            if test -d "$src" -a -z "$branch"
                set -l real_namespace (__fisher_plugin_get_url_info --dirname "$src")

                if test "$real_namespace" = "$names[2]"
                    if test ! -d "$fisher_config/$names[1]"
                        __fisher_log okay "Copy &$names[1]&" "$__fisher_stderr"
                    end

                    command cp -Rf "$src" "$fisher_config"
                else
                    set jobs $jobs (__fisher_plugin_url_clone_async "$i" "$names[1]" "$branch")
                end
            else
                set jobs $jobs (__fisher_plugin_url_clone_async "$i" "$names[1]" "$branch")
            end
        end

        set fetched $fetched "$names[1]"
    end

    __fisher_jobs_await $jobs

    for i in $fetched
        if test ! -d "$fisher_cache/$i"
            printf "%s\n" "$i"

            for i in $fetched
                if test -d "$fisher_config/$i"
                    command rm -rf "$fisher_config/$i"
                end
            end

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


function __fisher_plugin_url_clone_async -a url name branch
    switch "$url"
        case http://\* https://\*
        case {gitlab.com,github.com,bitbucket.org}\*
            set url "https://$url"

        case \?\*/\?\*
            set url "https://github.com/$url"

        case \*
            set url "https://github.com/fisherman/$url"
    end

    set -l nc (set_color normal)
    set -l error (set_color $fish_color_error)
    set -l okay (set_color $fish_color_match)
    set -l hm_url (printf "%s\n" "$url" | command sed 's|^https://||')

    if test ! -z "$branch"
        set hm_url "$hm_url ($branch)"
        set branch -b "$branch"
    end

    fish -c "
            set -lx GIT_ASKPASS /bin/echo

            if test -d '$fisher_cache/$name'
                command rm -rf '$fisher_cache/$name'
            end

            if command git clone $branch -q --depth 1 '$url' '$fisher_cache/$name' ^ /dev/null
                  printf '$okay""OK""$nc Fetch $okay%s$nc %s\n' '$name' '$hm_url' > $__fisher_stderr
                  command cp -Rf '$fisher_cache/$name' '$fisher_config'
            else
                  printf '$error""!""$nc Fetch $error%s$nc %s\n' '$name' '$hm_url' > $__fisher_stderr
            end
      " >&2

    __fisher_jobs_get -l
end


function __fisher_update
    set -l jobs
    set -l count (count $argv)
    set -l updated
    set -l links 0

    if test "$count" = 0
        return
    end

    if test "$count" -eq 1
        __fisher_log info "Updating &$count& plugin" "$__fisher_stderr"
    else
        __fisher_log info "Updating &$count& plugins" "$__fisher_stderr"
    end

    for i in $argv
        set -l name (__fisher_plugin_get_names "$i")[1]
        set -l path "$fisher_config/$name"

        if test -d "$path"
            set updated $updated "$name"

            if test -L "$fisher_config/$name"
                set links (math "$links + 1")
                continue
            end

            set jobs $jobs (__fisher_update_path_async "$name" "$path")
        else
            __fisher_log error "Skipped &$name&"
        end
    end

    __fisher_jobs_await $jobs

    set -g __fisher_fetch_plugins_state "fetching"
    set -l fetched (__fisher_plugin_fetch_items (__fisher_plugin_get_missing $updated))

    for i in $updated $fetched
        __fisher_plugin_enable "$fisher_config/$i"
    end

    if test "$links" -gt 0
        __fisher_log info "Synced &$links& symlink/s" "$__fisher_stderr"
    end
end


function __fisher_self_update
    set -l file (status --current-filename)

    if test "$file" != "$fish_path/functions/$fisher_cmd_name.fish"
        return 1
    end

    set -l completions "$fish_path/completions/$fisher_cmd_name.fish"
    set -l raw_url "https://raw.githubusercontent.com/fisherman/fisherman/master/fisher.fish"
    set -l fake_qs (date "+%s")

    set -l previous_version "$fisher_version"

    fish -c "curl --max-time 5 -sS '$raw_url?$fake_qs' > $file.$fake_qs" &

    __fisher_jobs_await (__fisher_jobs_get -l)

    if test -s "$file.$fake_qs"
        command mv "$file.$fake_qs" "$file"
    end

    builtin source "$file" ^ /dev/null

    echo "$fisher_cmd_name -v" | source > /dev/null

    set -l new_version "$fisher_version"

    echo "$fisher_cmd_name --complete" > "$completions"
    builtin source "$completions" ^ /dev/null

    if test "$previous_version" = "$fisher_version"
        __fisher_log okay "fisherman is up to date" "$__fisher_stderr"
    else
        __fisher_log okay "You are running fisherman &$fisher_version&" "$__fisher_stderr"
        __fisher_log info "See github.com/fisherman/fisherman/releases" "$__fisher_stderr"
    end
end


function __fisher_update_path_async -a name path
    set -l nc (set_color normal)
    set -l error (set_color $fish_color_match)
    set -l okay (set_color $fish_color_match)

    fish -c "

        pushd $path

        set -l branch (basename (command git symbolic-ref HEAD ^ /dev/null))
        set -l hm_branch

        if test -z \"\$branch\"
            set branch master
        end

        if test \"\$branch\" != master
            set hm_branch \" (\$branch)\"
        end

        if not command git fetch -q origin \$branch ^ /dev/null
            printf '$error""!""$nc Fetch $error%s$nc\n' '$name' > $__fisher_stderr
            exit
        end

        set -l commits (command git rev-list --left-right --count \$branch..FETCH_HEAD ^ /dev/null | cut -d\t -f2)

        command git reset -q --hard FETCH_HEAD ^ /dev/null
        command git clean -qdfx
        command cp -Rf '$path/.' '$fisher_cache/$name'

        if test -z \"\$commits\" -o \"\$commits\" -eq 0
            printf '$okay""OK""$nc Latest $okay%s$nc%s\n' '$name' \$hm_branch > $__fisher_stderr
        else
            printf '$okay""OK""$nc Pulled $okay%s$nc new commit/s $okay%s$nc%s\n' \$commits '$name' \$hm_branch > $__fisher_stderr
        end

    " >&2 &

    __fisher_jobs_get -l
end


function __fisher_plugin_enable -a path
    set -l plugin_name (basename $path)

    for file in $path/{functions/*,}*.fish
        set -l base (basename "$file")

        if test "$base" = "uninstall.fish"
            continue
        end

        switch "$base"
            case {,fish_{,user_}}key_bindings.fish
                __fisher_key_bindings_remove "$plugin_name"
                __fisher_key_bindings_append "$plugin_name" "$file"
                continue
        end

        set -l dir "functions"

        if test "$base" = "init.fish"
            set dir "conf.d"

            set base "$plugin_name.$base"
        end

        set -l target "$fish_path/$dir/$base"

        if test -e "$target" -a ! -L "$target"
            set -l backup_target "$fish_path/$dir/copy-$base"

            __fisher_log info "Backup &$base&" "$__fisher_stderr"

            command mv -f "$target" "$backup_target" ^ /dev/null
        end

        command ln -sf "$file" "$target"

        builtin source "$target" ^ /dev/null

        if test "$base" = "set_color_custom.fish"
            if test ! -s "$fish_path/fish_colors"
                __fisher_print_fish_colors > "$fish_path/fish_colors"
            end

            set_color_custom
        end
    end

    for file in $path/{functions/,}*.{py,awk}
        set -l base (basename "$file")
        command ln -sf "$file" "$fish_path/functions/$base"
    end

    for file in $path/conf.d/*.{py,awk}
        set -l base (basename "$file")
        command ln -sf "$file" "$fish_path/conf.d/$base"
    end

    for file in $path/conf.d/*.fish
        set -l base (basename "$file")
        set -l target "$fish_path/conf.d/$base"

        command ln -sf "$file" "$target"
        builtin source "$target" ^ /dev/null
    end

    for file in $path/completions/*.fish
        set -l base (basename "$file")
        set -l target "$fish_path/completions/$base"

        command ln -sf "$file" "$target"
        builtin source "$target" ^ /dev/null
    end

    return 0
end


function __fisher_plugin_disable -a path
    set -l plugin_name (basename $path)

    for i in "$path/functions/uninstall.fish" "$path/uninstall.fish"
        if test -s "$i"
            builtin source "$i" ^ /dev/null
            break
        end
    end

    for file in $path/{functions/*,}*.fish
        set -l name (basename "$file" .fish)
        set -l base "$name.fish"

        if test "$base" = "uninstall.fish"
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

        set -l target "$fish_path/$dir/$base"

        command rm -f "$target"

        functions -e "$name"

        set -l backup_source "$fish_path/$dir/copy-$base"

        if test -e "$backup_source"
            command mv "$backup_source" "$target"
            builtin source "$target" ^ /dev/null
        end

        if test "$base" = "set_color_custom.fish"
            set -l fish_colors_config "$fish_path/fish_colors"

            if test ! -f "$fish_colors_config"
                __fisher_reset_default_fish_colors
                continue
            end

            __fisher_restore_fish_colors < $fish_colors_config | builtin source ^ /dev/null

            command rm -f $fish_colors_config
        end
    end

    for file in $path/conf.d/*.{py,awk}
        set -l base (basename "$file")
        command rm -f "$fish_path/conf.d/$base"
    end

    for file in $path/{functions/,}*.{py,awk}
        set -l base (basename "$file")
        command rm -f "$fish_path/functions/$base"
    end

    for file in $path/conf.d/*.fish
        set -l base (basename "$file")
        command rm -f "$fish_path/conf.d/$base"
    end

    for file in $path/completions/*.fish
        set -l name (basename "$file" .fish)
        set -l base "$name.fish"

        command rm -f "$fish_path/completions/$base"
        complete -c "$name" --erase
    end

    if __fisher_plugin_is_prompt "$path"
        set -U fisher_active_prompt
        builtin source $__fish_datadir/functions/fish_prompt.fish ^ /dev/null
    end

    command rm -rf "$path" >&2
end


function __fisher_remove
    if test -z "$argv"
        return 1
    end

    set -l orphans
    set -l removed

    for i in $argv
        set -l name (__fisher_plugin_get_names "$i")[1]

        if test ! -d "$fisher_config/$name"
            continue
        end

        set removed $removed $name

        __fisher_show_spinner
        __fisher_plugin_decrement_ref_count "$name"

        if test -s "$fisher_config/$name/fishfile"
            while read -l i
                set -l name (__fisher_plugin_get_names "$i")[1]

                if test (__fisher_plugin_get_ref_count "$name") -le 1
                    set orphans $orphans "$name"
                else
                    __fisher_plugin_decrement_ref_count "$name"
                end

                __fisher_show_spinner
            end < "$fisher_config/$name/fishfile"
        end

        __fisher_plugin_disable "$fisher_config/$name"

        __fisher_show_spinner
    end

    for i in $orphans
        __fisher_remove "$i" >&2
    end
end


function __fisher_get_plugin_name_from_gist -a url
    set -l gist_id (printf "%s\n" "$url" | command sed 's|.*/||')
    set -l name (fish -c "

        $fisher_cmd_name -v > /dev/null
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


function __fisher_remote_parse_header
    command awk '

        function get_page_count(s, rstart, rlength,    pages) {
            if (split(substr(s, rstart, rlength), pages, "=")) {
                return pages[2]
            }
        }

        BEGIN {
            FS = " <|>; |, <"
        }

        /^Link: / {
            if (match($2, "&page=[0-9]*")) {
                url = substr($2, 1, RSTART - 1)
                page_next = get_page_count($2, RSTART, RLENGTH)

                if (page_next) {
                    page_last = get_page_count($4, RSTART, RLENGTH)

                    printf("%s\n%s\n%s", url, page_next, page_last)
                }
            }
        }

    '
end


function __fisher_remote_index_update
    set -l index "$fisher_cache/.index"
    set -l interval 3240
    set -l players "fisherman" "oh-my-fish"

    if test ! -z "$fisher_index_update_interval"
        set interval "$fisher_index_update_interval"
    end

    if test -s "$index"
        if set -l file_age (__fisher_get_file_age "$index")
            if test "$file_age" -lt "$interval"
                return
            end
        end
    end

    for i in $players
        curl -u$GITHUB_USER:$GITHUB_TOKEN -Is "https://api.github.com/orgs/$i/repos?per_page=100" > "$index-header-$i" &
    end

    __fisher_jobs_await (__fisher_jobs_get -l)

    for i in $players
        set -l url "https://api.github.com/orgs/$i/repos?per_page=100"
        set -l next 0
        set -l last 0
        set -l data

        if test -s "$index-header-$i"
            __fisher_remote_parse_header < "$index-header-$i" | read -az data
            command rm -f "$index-header-$i"
        end

        if set -q data[3]
            set -l url "$data[1]"
            set -l next "$data[2]"
            set -l last "$data[3]"
        end

        for page in "" (seq "$next" "$last")
            if test "$page" = 0
                continue
            end

            set -l next_url "$url"

            if test ! -z "$page"
                set next_url "$url&page=$page"
            end

            curl -u$GITHUB_USER:$GITHUB_TOKEN --max-time 10 -s "$next_url" | command awk -v ORS='' '

                {
                    gsub(/[{}[]]/, "")

                } //

            ' | command awk '

                {
                    n = split($0, a, /,[\t ]*"/)

                    for (i = 1; i <= n; i++) {
                        gsub(/"/, "", a[i])
                        print(a[i])
                    }
                }

            ' > "$index-$i-$page" &
        end
    end

    __fisher_jobs_await (__fisher_jobs_get -l)

    for i in $players
        command cat "$index-$i-"*
    end > "$index"

    command rm "$index"-*

    if test ! -s "$index"
        return 1
    end

    command awk '

        function quicksort(list, lo, hi, pivot,   j, i, t) {
            pivot = j = i = t

            if (lo >= hi) {
                return
            }

            pivot = lo
            i = lo
            j = hi

            while (i < j) {
                while (list[i] <= list[pivot] && i < hi) {
                    i++
                }

                while (list[j] > list[pivot]) {
                    j--
                }

                if (i < j) {
                    t = list[i]
                    list[i] = list[j]
                    list[j] = t
                }
            }

            t = list[pivot]

            list[pivot] = list[j]
            list[j] = t

            quicksort(list, lo, j - 1)
            quicksort(list, j + 1, hi)
        }

        function reset_vars() {
            name = info = stars = url = ""
        }

        {
            if ($0 ~ /^name: /) {
                name = substr($0, 7)
            }

            if ($0 ~ /^description: /) {
                info = substr($0, 14)
            }

            if ($0 ~ /^stargazers_count: /) {
                stars = substr($0, 19)
            }

            if (name != "" && stars != "") {
                if (name ~ /oh-my-fish/) {
                    reset_vars()
                    next
                }

                url = "github.com/fisherman/" name

                if (name ~ /^(plugin|theme)-/) {
                    gsub(/^plugin-/, "", name)

                    if (seen_names[name]) {
                        reset_vars()
                        next
                    }

                    url = "github.com/oh-my-fish/" name
                    name = "omf/" name

                } else {
                    seen_names[name]++
                }

                if (info == "" || info == "null") {
                    info = url
                }

                if (info ~ /\.$/) {
                    info = substr(info, 1, length(info) - 1)
                }

                records[++record_count] = name "\t" info "\t" url "\t" stars
                reset_vars()
            }
        }

        END {
            quicksort(records, 1, record_count)

            for (i = 1; i <= record_count; i++) {
                print(records[i])
            }
        }

    ' < "$index" > "$index-tab"

    if test ! -s "$index-tab"
        command rm "$index"
        return 1
    end

    command mv -f "$index-tab" "$index"
end


function __fisher_list_remote -a format
    set -l index "$fisher_cache/.index"

    if not __fisher_remote_index_update
        __fisher_log error "I could not update the remote index."
        __fisher_log info "

            This is most likely a problem with http://api.github.com/
            or a connection timeout. If the problem persists, open an
            issue in: <github.com/fisherman/fisherman/issues>
        "

        return 1
    end

    set -e argv[1]
    set -l keys $argv

    command awk -v FS=\t -v format_s="$format" -v keys="$keys" '

        function basename(s,   n, a) {
            n = split(s, a, "/")
            return a[n]
        }

        function record_printf(fmt, name, info, url, stars) {
            gsub(/%name/, name, fmt)
            gsub(/%stars/, stars, fmt)
            gsub(/%url/, url, fmt)
            gsub(/%info/, info, fmt)

            printf("%s", fmt)
        }

        BEGIN {
            keys_n = split(keys, keys_a, " ")
        }

        {
            if (keys_n > 0) {
                for (i = 1; i <= keys_n; i++) {
                    if (keys_a[i] == $1) {
                        record_printf(format_s, $1, $2, $3, $4)
                        next
                    }
                }
            } else if ($1 !~ /^fisherman/) {
                record_printf(format_s, $1, $2, $3, $4)
            }
        }

    ' < "$index"
end


function __fisher_list
    set -l config "$fisher_config"/*

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


function __fisher_list_plugin_directory
    if test -z "$argv"
        return 1
    end

    for i in $argv
        if test ! -d "$fisher_config/$i"
            __fisher_log error "You can only list plugins you've installed." "$__fisher_stderr"

            return 1
        end
    end

    set -l fd "$__fisher_stderr"
    set -l uniq_items

    for i in $argv
        if contains -- "$i" $uniq_items
            continue
        end

        set uniq_items $uniq_items "$i"
        set -l path "$fisher_config/$i"

        pushd "$path"

        set -l color (set_color $fish_color_command)
        set -l nc (set_color normal)
        set -l previous_tree

        if contains -- --no-color $argv
            set color
            set nc
            set fd "$__fisher_stdout"
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
end


function __fisher_log -a log message fd
    if test -z "$argv"
        return
    end

    switch "$fd"
        case "/dev/null"
            return

        case "" "/dev/stderr"
            set fd $__fisher_stderr

        case \*
            set nc ""
            set okay ""
            set info ""
            set error ""
    end

    set -l nc (set_color normal)
    set -l okay (set_color $fish_color_match)
    set -l info (set_color $fish_color_match)
    set -l error (set_color $fish_color_error)

    printf "%s\n" "$message" | command awk '
        function okay(s) {
            printf("'"$okay"'%s'"$nc"' %s\n", "OK", s)
        }

        function info(s) {
            printf("%s\n", s)
        }

        function error(s) {
            printf("'"$error"'%s'"$nc"' %s\n", "!", s)
        }

        {
            sub(/^[ ]+/, "")
            gsub("``", "  ")

            if (/&[^&]+&/) {
                n = match($0, /&[^&]+&/)
                if (n) {
                    sub(/&[^&]+&/, "'"$$log"'" substr($0, RSTART + 1, RLENGTH - 2) "'"$nc"'", $0)
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
                    '"$log"'(s[i])
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
            printf "  $spinner  \r" >&2
            sleep 0.05
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
    set -l user_key_bindings "$fish_path/functions/fish_user_key_bindings.fish"

    if test ! -f "$user_key_bindings"
        return
    end

    set -l tmp (date "+%s")

    fish_indent < "$user_key_bindings" | command sed -n "/### $plugin_name ###/,/### $plugin_name ###/{s/^ *bind /bind -e /p;};" | builtin source ^ /dev/null

    command sed "/### $plugin_name ###/,/### $plugin_name ###/d" < "$user_key_bindings" > "$user_key_bindings.$tmp"
    command mv -f "$user_key_bindings.$tmp" "$user_key_bindings"

    if command awk '
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
    set -l user_key_bindings "$fish_path/functions/fish_user_key_bindings.fish"

    command mkdir -p (dirname "$user_key_bindings")
    command touch "$user_key_bindings"

    set -l key_bindings_source (
        fish_indent < "$user_key_bindings" | command awk '

            /^function fish_user_key_bindings/ {
                reading_function_source = 1
                next
            }

            /^end$/ && reading_function_source {
                exit
            }

            reading_function_source {
                print($0)
                next
            }

        '
    )

    set -l plugin_key_bindings_source (
        fish_indent < "$file" | command awk -v name="$plugin_name" '

            BEGIN {
                printf("### %s ###\n", name)
            }

            END {
                printf("### %s ###\n", name)
            }

            /^function (fish_(user_)?)?key_bindings$/ {
                is_end = 1
                next
            }

            /^end$/ && is_end {
                end = 0
                next
            }

            !/^ *(#.*)*$/ {
                gsub("#.*", "")
                printf("%s\n", $0)
            }

        '
    )

    printf "%s\n" $plugin_key_bindings_source | source ^ /dev/null

    fish_indent < "$user_key_bindings" | command awk '
        {

            if ($0 ~ /^function fish_user_key_bindings/) {
                reading_function_source = 1
                next
            } else if ($0 ~ /^end$/ && reading_function_source) {
                reading_function_source = 0
                next
            }

            if (!reading_function_source) {
                print($0)
            }
        }

    ' > "$user_key_bindings-copy"

    command mv -f "$user_key_bindings-copy" "$user_key_bindings"

    printf "%s\n" $key_bindings_source $plugin_key_bindings_source | command awk '

        BEGIN {
            print "function fish_user_key_bindings"
        }

        //

        END {
            print "end"
        }

    ' | fish_indent >> "$user_key_bindings"
end


function __fisher_plugin_is_prompt -a path
    for file in "$path"/{,functions/}{fish_prompt,fish_right_prompt}.fish
        if test -e "$file"
            return
        end
    end

    return 1
end


function __fisher_plugin_get_names
    printf "%s\n" $argv | command awk '

        {
            sub(/\/$/, "")
            n = split($0, s, "/")
            sub(/^(omf|omf-theme|omf-plugin|plugin|theme|fish|fisher|fish-plugin|fish-theme)-/, "", s[n])

            printf("%s\n%s\n", s[n], s[n - 1])
        }

    '
end


function __fisher_plugin_get_url_info -a option
    set -e argv[1]

    if test -z "$argv"
        return
    end

    for dir in $argv
        git -C $dir config remote.origin.url ^ /dev/null | command awk -v option="$option" '
            {
                n = split($0, s, "/")

                if ($0 ~ /https:\/\/gist/) {
                    printf("# %s\n", $0)
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

        if test "$name" = fisherman

            __fisher_log info "
                Run &$fisher_cmd_name update& to update fisherman.
            " >&2
            continue
        end

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


function __fisher_print_fish_colors
    printf "%s\n" "$fish_color_normal" "$fish_color_command" "$fish_color_param" "$fish_color_redirection" "$fish_color_comment" "$fish_color_error" "$fish_color_escape" "$fish_color_operator" "$fish_color_end" "$fish_color_quote" "$fish_color_autosuggestion" "$fish_color_user" "$fish_color_valid_path" "$fish_color_cwd" "$fish_color_cwd_root" "$fish_color_match" "$fish_color_search_match" "$fish_color_selection" "$fish_pager_color_prefix" "$fish_pager_color_completion" "$fish_pager_color_description" "$fish_pager_color_progress" "$fish_color_history_current" "$fish_color_host"
end


function __fisher_restore_fish_colors
    command awk '
        {
            if ($0 == "") {
                set_option "-e"
            } else {
                set_option "-U"
            }
        }

        NR == 1 {
            print("set " set_option " fish_color_normal " $0)
        }
        NR == 2 {
            print("set " set_option " fish_color_command " $0)
        }
        NR == 3 {
            print("set " set_option " fish_color_param " $0)
        }
        NR == 4 {
            print("set " set_option " fish_color_redirection " $0)
        }
        NR == 5 {
            print("set " set_option " fish_color_comment " $0)
        }
        NR == 6 {
            print("set " set_option " fish_color_error " $0)
        }
        NR == 7 {
            print("set " set_option " fish_color_escape " $0)
        }
        NR == 8 {
            print("set " set_option " fish_color_operator " $0)
        }
        NR == 9 {
            print("set " set_option " fish_color_end " $0)
        }
        NR == 10 {
            print("set " set_option " fish_color_quote " $0)
        }
        NR == 11 {
            print("set " set_option " fish_color_autosuggestion " $0)
        }
        NR == 12 {
            print("set " set_option " fish_color_user " $0)
        }
        NR == 13 {
            print("set " set_option " fish_color_valid_path " $0)
        }
        NR == 14 {
            print("set " set_option " fish_color_cwd " $0)
        }
        NR == 15 {
            print("set " set_option " fish_color_cwd_root " $0)
        }
        NR == 16 {
            print("set " set_option " fish_color_match " $0)
        }
        NR == 17 {
            print("set " set_option " fish_color_search_match " $0)
        }
        NR == 18 {
            print("set " set_option " fish_color_selection " $0)
        }
        NR == 19 {
            print("set " set_option " fish_pager_color_prefix " $0)
        }
        NR == 20 {
            print("set " set_option " fish_pager_color_completion " $0)
        }
        NR == 21 {
            print("set " set_option " fish_pager_color_description " $0)
        }
        NR == 22 {
            print("set " set_option " fish_pager_color_progress " $0)
        }
        NR == 23 {
            print("set " set_option " fish_color_history_current " $0)
        }
        NR == 24 {
            print("set " set_option " fish_color_host " $0)
        }

    '
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
        /^$/ || /^[ \t]*#/ || /^(--|-).*/ {
            next
        }

        /^omf\// {
            sub(/^omf\//, "oh-my-fish/")

            if ($0 !~ /(theme|plugin)-/) {
                sub(/^oh-my-fish\//, "oh-my-fish/plugin-")
            }
        }

        /^[ \t]*package / {
            sub("^[ \t]*package ", "oh-my-fish/plugin-")
        }

        {
            sub(/\.git$/, "")
            sub("^[@* \t]*", "")

            if (!dedupe[$0]++) {
                printf("%s\n", $0)
            }
        }
    '
end


function __fisher_plugin_increment_ref_count -a name
    set -U fisher_dependency_count $fisher_dependency_count $name
end


function __fisher_plugin_decrement_ref_count -a name
    if set -l i (contains --index -- "$name" $fisher_dependency_count)
        set -e fisher_dependency_count[$i]
    end
end


function __fisher_plugin_get_ref_count -a name
    printf "%s\n" $fisher_dependency_count | command awk -v plugin="$name" '

        BEGIN {
            i = 0
        }

        $0 == plugin {
            i++
        }

        END {
            print(i)
        }

    '
end


function __fisher_complete
    complete -xc $fisher_cmd_name -n "__fish_use_subcommand" -a install   -d "Install plugins"
    complete -xc $fisher_cmd_name -n "__fish_use_subcommand" -a update    -d "Update plugins and self"
    complete -xc $fisher_cmd_name -n "__fish_use_subcommand" -a rm        -d "Remove plugins"
    complete -xc $fisher_cmd_name -n "__fish_use_subcommand" -a ls        -d "List what you've installed"
    complete -xc $fisher_cmd_name -n "__fish_use_subcommand" -a ls-remote -d "List everything that's available"
    complete -xc $fisher_cmd_name -n "__fish_use_subcommand" -a help      -d "Show help"

    complete -xc $fisher_cmd_name -n "__fish_use_subcommand" -s h -l help     -d "Show usage help"
    complete -xc $fisher_cmd_name -n "__fish_use_subcommand" -s v -l version  -d "Show version information"
    complete -xc $fisher_cmd_name -s q -l quiet -d "Enable quiet mode"

    complete -xc $fisher_cmd_name -n "__fish_seen_subcommand_from ls-remote" -l "format" -d "Format with verbs: %name, %url, %info and %stars"

    set -l config_glob "$fisher_config"/*
    set -l config (printf "%s\n" $config_glob | command sed "s|.*/||")

    if test ! -s "$fisher_cache/.index"
        if test ! -z "$config"
            complete -xc $fisher_cmd_name -n "__fish_seen_subcommand_from l ls list u up update r rm remove h help" -a "$config"
            complete -xc $fisher_cmd_name -n "__fish_seen_subcommand_from l ls list u up update r rm remove h help" -a "$fisher_active_prompt" -d "Prompt"
        end
        return
    end

    set -l real_home ~

    for name in (command find $config_glob -maxdepth 0 -type l ^ /dev/null)
        set -l path (command readlink "$name")
        set -l name (command basename "$name" | sed "s|$real_home|~|")

        complete -xc $fisher_cmd_name -n "__fish_seen_subcommand_from l ls list u up update r rm remove h help" -a "$name" -d "$path"
    end

    set -l IFS \t

    command awk -v FS=\t -v OFS=\t '

        {
            print($1, $2)
        }

    ' "$fisher_cache/.index" ^ /dev/null | while read -l name info

        switch "$name"
            case fisherman\*
                continue
        end

        complete -xc $fisher_cmd_name -n "__fish_seen_subcommand_from info ls-remote" -a "$name" -d "$info"

        if contains -- "$name" $config
            complete -xc $fisher_cmd_name -n "__fish_seen_subcommand_from l ls list u up update r rm remove h help" -a "$name" -d "$info"
        else
            complete -xc $fisher_cmd_name -n "__fish_seen_subcommand_from i in install" -a "$name" -d "$info"
        end
    end

    if functions -q __fisher_plugin_get_url_info
        for i in (__fisher_plugin_get_url_info -- $config_glob)
            switch "$i"
                case fisherman\*
                case \*
                    set -l name (__fisher_plugin_get_names "$i")[1]
                    complete -xc $fisher_cmd_name -n "__fish_seen_subcommand_from l ls list u up update r rm remove h help" -a "$name" -d "$i"
            end
        end
    end
end


function __fisher_humanize_duration
    command awk '
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
    printf "$argv" >&2
    while true
        dd bs=1 count=1 ^ /dev/null | read -p "" -l yn
        switch "$yn"
            case y Y n N
                printf "\n" >&2
                printf "%s\n" $yn > /dev/stdout
                break
        end
    end
    stty icanon echo > /dev/stderr ^ /dev/null
end


switch (command uname)
    case Darwin FreeBSD
        function __fisher_get_epoch_in_ms -a elapsed
            if test -z "$elapsed"
                set elapsed 0
            end

            if command -s perl > /dev/null
                perl -MTime::HiRes -e 'printf("%.0f\n", (Time::HiRes::time() * 1000) - '$elapsed')'
            else
                math (command date "+%s") - $elapsed
            end
        end

    case \*
        function __fisher_get_epoch_in_ms -a elapsed
            if test -z "$elapsed"
                set elapsed 0
            end
            math (command date "+%s%3N") - $elapsed
        end
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


function __fisher_get_file_age -a file
    if type -q perl
        perl -e "printf(\"%s\n\", time - (stat ('$file'))[9])" ^ /dev/null

    else if type -q python
        python -c "from __future__ import print_function; import os, time; print(int(time.time() - os.path.getmtime('$file')))" ^ /dev/null
    end
end


function __fisher_usage
    set -l u (set_color -u)
    set -l nc (set_color normal)

    echo "Usage: $fisher_cmd_name [COMMAND] [PLUGINS]"
    echo
    echo "where COMMAND is one of:"
    echo "      "$u"i"$nc"nstall (default)"
    echo "      "$u"u"$nc"pdate"
    echo "      "$u"r"$nc"m"
    echo "      "$u"l"$nc"s (or ls-remote [--format=FORMAT])"
    echo "      "$u"h"$nc"elp"
end


function __fisher_version
    set -l real_home ~
    printf "fisherman version $fisher_version %s\n" (
        __fisher_plugin_normalize_path (status -f) | command sed "s|$real_home|~|;s|$__fish_datadir|\$__fish_datadir|")
end

function __fisher_help -a cmd number
    if test -z "$argv"
        set -l page "$fisher_cache/$fisher_cmd_name.1"

        if test ! -s "$page"
            __fisher_man_page_write > "$page"
        end

        if [ "$PREFIX" = "/data/data/com.termux/files/usr" ]

          mandoc -a "$page"

        else

          set -l pager "/usr/bin/less -s"

          if test ! -z "$PAGER"
              set pager "$PAGER"
          end

          man -P "$pager" -- "$page"

        end

        command rm -f "$page"

    else
        if test -z "$number"
            set number 1
        end

        set -l page "$fisher_config/$cmd/man/man$number/$cmd.$number"

        if not man "$page" ^ /dev/null
            if test -d "$fisher_config/$cmd"
                __fisher_log info "There's no manual for this plugin." "$__fisher_stderr"

                set -l url (__fisher_plugin_get_url_info -- "$fisher_config/$cmd")

                __fisher_log info "Try online: <&github.com/$url&>" "$__fisher_stderr"
            else
                __fisher_log error "This plugin is not installed." "$__fisher_stderr"
            end

            return 1
        end
    end
end


function __fisher_self_uninstall -a yn
    set -l file (status --current-filename)
    set -l u (set_color -u)
    set -l nc (set_color normal)

    switch "$yn"
        case -y --yes
        case \*
            __fisher_log info "
                This will permanently remove fisherman from your system.
                The following directories and files will be erased:

                $fisher_cache
                $fisher_config
                $fish_config/functions/$fisher_cmd_name.fish
                $fish_config/completions/$fisher_cmd_name.fish

            " >&2

            echo -sn "Continue? [Y/n] " >&2

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

    complete -c $fisher_cmd_name --erase

    __fisher_show_spinner

    echo "$fisher_cmd_name ls | $fisher_cmd_name rm -q" | source ^ /dev/null

    __fisher_show_spinner

    command rm -rf "$fisher_cache" "$fisher_config"
    command rm -f "$fish_config"/{functions,completions}/$fisher_cmd_name.fish "$fisher_file"

    set -e fish_config
    set -e fish_path
    set -e fisher_active_prompt
    set -e fisher_cache
    set -e fisher_config
    set -e fisher_file
    set -e fisher_version
    set -e fisher_spinners

    __fisher_log info "Done." "$__fisher_stderr"

    set -l funcs (functions -a | command grep __fisher)

    functions -e $funcs $fisher_cmd_name
end


function __fisher_man_page_write
    echo  '.
.TH "FISHERMAN" "1" "May 2016" "" "fisherman"
.
.SH "NAME"
\fBfisherman\fR \- fish plugin manager
.
.SH "SYNOPSIS"
'"$fisher_cmd_name"' [(\fBi\fRnstall | \fBu\fRpdate | \fBl\fRs[\-remote] | \fBr\fRm | \fBh\fRelp) PLUGINS]
.
.br
.
.SH "DESCRIPTION"
A plugin manager for fish\.
.
.SH "OPTIONS"
.
.IP "\(bu" 4
\-v, \-\-version: Show version information\.
.
.IP "\(bu" 4
\-h, \-\-help: Show usage help\. Use the long form to display this page\.
.
.IP "\(bu" 4
\-q, \-\-quiet: Enable quiet mode\. Use to suppress output\.
.
.IP "" 0
.
.SH "USAGE"
Install a plugin\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' mono
.
.fi
.
.IP "" 0
.
.P
Install some plugins\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' z fzf edc/bass omf/tab
.
.fi
.
.IP "" 0
.
.P
Install a specific branch\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' edc/bass:master
.
.fi
.
.IP "" 0
.
.P
Install a specific tag\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' done@1.2.0
.
.fi
.
.IP "" 0
.
.P
Install a gist\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' https://gist\.github\.com/username/1f40e1c6e0551b2666b2
.
.fi
.
.IP "" 0
.
.P
Install a local directory\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' ~/my/plugin
.
.fi
.
.IP "" 0
.
.P
Edit your \fIfishfile\fR and run \fB'"$fisher_cmd_name"'\fR to commit changes\.
.
.IP "" 4
.
.nf

$EDITOR ~/\.config/fish/fishfile
'"$fisher_cmd_name"'
.
.fi
.
.IP "" 0
.
.P
Show everything you\'ve installed\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' ls
@ plugin     # a local directory
* mono       # the current prompt
  bass
  fzf
  thefuck
  z
.
.fi
.
.IP "" 0
.
.P
Show everything that\'s available\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' ls\-remote
.
.fi
.
.IP "" 0
.
.P
Update everything\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' up
.
.fi
.
.IP "" 0
.
.P
Update some plugins\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' up bass z fzf
.
.fi
.
.IP "" 0
.
.P
Remove plugins\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' rm thefuck
.
.fi
.
.IP "" 0
.
.P
Remove all the plugins\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' ls | '"$fisher_cmd_name"' rm
.
.fi
.
.IP "" 0
.
.P
Get help\.
.
.IP "" 4
.
.nf

'"$fisher_cmd_name"' help z
.
.fi
.
.IP "" 0
.
.SH "FAQ"
.
.SS "What is the required fish version?"
>=2\.2\.0\.
.
.P
For \fIsnippet\fR support, upgrade to >=2\.3\.0 or append the following code to your \fI~/\.config/fish/config\.fish\fR\.
.
.IP "" 4
.
.nf

for file in ~/\.config/fish/conf\.d/*\.fish
    source $file
end
.
.fi
.
.IP "" 0
.
.SS "Is fisherman compatible with oh\-my\-fish themes and plugins?"
Yes\.
.
.SS "Where does fisherman put stuff?"
The cache and configuration go in \fI~/\.cache/fisherman\fR and \fI~/\.config/fisherman\fR respectively\.
.
.P
The fishfile is saved to \fI~/\.config/fish/fishfile\fR\.
.
.SS "What is a fishfile and how do I use it?"
The fishfile \fI~/\.config/fish/fishfile\fR lists what plugins you\'ve installed\.
.
.P
This file is updated automatically as you install / remove plugins. You can also edit this file and run \fBfisher\fR to commit changes\.
.
.P
This mechanism only installs plugins and missing dependencies\. To remove plugins, use \fBfisher rm\fR\.
.
.SS "What is a plugin?"
A plugin is:
.
.IP "1." 4
a directory or git repo with one or more \fI\.fish\fR functions either at the root level of the project or inside a \fIfunctions\fR directory
.
.IP "2." 4
a theme or prompt, i\.e, a \fIfish_prompt\.fish\fR, \fIfish_right_prompt\.fish\fR or both files
.
.IP "3." 4
a snippet, i\.e, one or more \fI\.fish\fR files inside a directory named \fIconf\.d\fR, evaluated by fish at the start of the session
.
.IP "" 0
.
.SS "How can I list plugins as dependencies to my plugin?"
Create a new \fIfishfile\fR file at the root level of your project and write in the plugins\.'
end
