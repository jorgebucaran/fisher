function fisher_uninstall -d "Uninstall Plugins"
    set -l plugins
    set -l option
    set -l stdout /dev/stdout
    set -l stderr /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set plugins $plugins $2

            case f force
                set option force

            case q quiet
                set stdout /dev/null
                set stderr /dev/null

            case h
                printf "usage: fisher uninstall [<plugins>] [--force] [--quiet] [--help]\n\n"

                printf "    -f --force  Delete copy from cache\n"
                printf "    -q --quiet  Enable quiet mode\n"
                printf "     -h --help  Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 >& /dev/stderr
                fisher_uninstall -h >& /dev/stderr
                return 1
        end
    end

    set -l time (date +%s)
    set -l count 0
    set -l index 1
    set -l total (count $plugins)
    set -l skipped

    if set -q plugins[1]

        printf "%s\n" $plugins
    else
        __fisher_file

    end | while read -l item path

        if not set item (__fisher_plugin_validate $item)
            printf "fisher: '%s' is not a valid name, path or url.\n" $item > $stderr
            continue
        end

        if not set path (__fisher_path_from_plugin $item)
            set total (math $total - 1)
            printf "fisher: '%s' not found\n" $item > $stderr
            continue
        end

        set -l name (printf "%s\n" $path | __fisher_name)

        if not contains -- $name (__fisher_list $fisher_file)
            if test -z "$option"
                set total (math $total - 1)
                set skipped $skipped $name
                continue
            end
        end

        printf "Uninstalling " > $stderr

        switch $total
            case 0 1
                printf ">> %s\n" $name > $stderr

            case \*
                printf "(%s of %s) >> %s\n" $index $total $name > $stderr
                set index (math $index + 1)
        end

        if begin not __fisher_path_is_prompt $path; or test "$name" = "$fisher_prompt"; end

            # You can use --force to remove any plugin from the cache. If prompt A is enabled
            # you can still uninstall prompt B using --force. This will delete B's repository
            # from $fisher_cache.

            __fisher_plugin_disable "$name" "$path"
        end

        if test "$option" = force
            command rm -rf $path
        end

        set count (math $count + 1)
    end

    set time (math (date +%s) - $time)

    if test ! -z "$skipped"
        printf "%s plugin/s skipped (%s)\n" (count $skipped) (
            printf "%s\n" $skipped | paste -sd ' ' -
            ) > $stdout
    end

    if test $count -le 0
        printf "No plugins were uninstalled.\n" > $stdout
        return 1
    end

    __fisher_complete_reset
    __fisher_key_bindings_reset

    printf "Aye! %d plugin/s uninstalled in %0.fs\n" $count $time > $stdout
end
