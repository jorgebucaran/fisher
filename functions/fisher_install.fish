function fisher_install -d "Install Plugins"
    set -l plugins
    set -l option
    set -l error /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set plugins $plugins $2

            case f force
                set option force

            case q quiet
                set error /dev/null

            case h
                printf "usage: fisher install [<plugins>] [--force] [--quiet] [--help]\n\n"

                printf "    -f --force  Reinstall given plugin/s\n"
                printf "    -q --quiet  Enable quiet mode\n"
                printf "     -h --help  Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 >& 2
                fisher_install -h >& 2
                return 1
        end
    end

    set -l link
    set -l time (date +%s)
    set -l count 0
    set -l index 1
    set -l total (count $plugins)
    set -l skipped

    if set -q plugins[1]

        printf "%s\n" $plugins
    else
        __fisher_file

    end | while read -l item

        if not set item (__fisher_plugin_validate $item)
            printf "fisher: '%s' is not a valid name, path or url.\n" $item > $error
            continue
        end

        switch "$item"
            case \*/\*
                printf "%s %s\n" $item (printf "%s\n" $item | __fisher_name)

            case \*
                if set -l url (fisher_search --url --name=$item --index=$fisher_cache/.index)
                    printf "%s %s\n" $url $item

                else if test -d $fisher_cache/$item
                    printf "%s %s\n" (__fisher_url_from_path $fisher_cache/$item) $item

                else
                    set total (math $total - 1)
                    printf "fisher: '%s' not found.\n" $item > $error
                end
        end

    end | while read -l url name

        if contains -- $name (__fisher_list $fisher_file)
            if test -z "$option"
                set total (math $total - 1)
                set skipped $skipped $name
                continue
            end
        end

        printf "Installing " > $error

        switch $total
            case 0 1
                printf ">> %s\n" $name > $error

            case \*
                printf "(%s of %s) >> %s\n" $index $total $name > $error
                set index (math $index + 1)
        end

        mkdir -p $fisher_config/{functions,scripts,completions,conf.d,man} $fisher_cache

        set -l path $fisher_cache/$name

        if test ! -e $path
            if test -d "$url"
                ln -sfF $url $path

            else if not wait "__fisher_url_clone $url $path"
                printf "fisher: Repository not found: '%s'\n" $url > $error

                switch "$url"
                    case \*oh-my-fish\*
                        printf "Did you miss a 'plugin-' or 'theme-' prefix?\n" > $error
                end

                continue
            end
        end

        set -l deps (__fisher_deps_install "$path")

        if not __fisher_path_make "$path" --quiet
            printf "fisher: Failed to build '%s'. See '%s/Makefile'.\n" $name $path > $error
        end

        __fisher_plugin_enable "$name" "$path"

        set count (math $count + 1 + "0$deps")
    end

    set time (math (date +%s) - $time)

    if test ! -z "$skipped"
        printf "%s plugin/s skipped (%s)\n" (count $skipped) (
            printf "%s\n" $skipped | paste -sd ' ' -) > $error
    end

    if test "$count" -le 0
        printf "No plugins were installed.\n" > $error
        return 1
    end

    __fisher_complete_reset
    __fisher_key_bindings_reset

    printf "Aye! %d plugin/s installed in %0.fs\n" $count $time > $error
end
