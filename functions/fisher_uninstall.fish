function fisher_uninstall -d "Uninstall plugins (r)"
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

                if test ! -z "$2"
                    set plugins $plugins $2
                end

            case q quiet
                set stdout /dev/null
                set stderr /dev/null

            case h
                printf "Usage: fisher uninstall [<plugins>] [--force] [--quiet] [--help]\n\n"
                printf "    -f --force    Delete copy from the cache\n"
                printf "    -q --quiet    Enable quiet mode\n"
                printf "    -h --help     Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option\n" $1 > /dev/stderr
                fisher_uninstall -h > /dev/stderr
                return 1
        end
    end

    set -l count 0
    set -l skipped
    set -l time (date +%s)

    set -l IFS \t

    printf "Uninstalling\n" > $stderr

    if set -q plugins[1]
        printf "%s\n" $plugins
    else
        __fisher_file

    end | while read -l item path
        debug "validate %s" $item

        if not set item (__fisher_plugin_validate $item)
            debug "validate fail %s" $item
            printf "fisher: '%s' is not a valid plugin\n" $item > $stderr
            continue
        end

        debug "validate ok %s" $item

        if not set path (__fisher_path_from_plugin $item)
            printf "fisher: I could not find '%s'\n" $item > $stderr
            continue
        end

        set -l name (printf "%s\n" $path | __fisher_name)

        if not contains -- $name (fisher_list --enabled)
            if test -z "$option"
                debug "skip %s" "$name"

                set skipped $skipped $name
                continue
            end
        end

        printf "    %-22s\n" "$name" > $stdout
        debug "uninstall %s" "$name"

        if __fisher_plugin_can_enable "$name" "$path"
            __fisher_plugin_disable "$name" "$path" "$option"
            debug "disable %s[:%s]" "$name" "$option"
        end

        if test "$option" = force
            command rm -rf $path
            debug "remove %s" "$path"
        end

        set count (math $count + 1)
    end

    set time (math (date +%s) - $time)

    if test ! -z "$skipped"
        printf "%s plugin/s skipped (%s)\n" (count $skipped) (
            printf "%s\n" $skipped | paste -sd ' ' -
            ) > $stderr
    end

    if test $count -le 0
        printf "No plugins were uninstalled\n" > $stderr
        return 1
    end

    __fisher_complete_reset
    __fisher_key_bindings_reset

    debug "complete / key bindings reset"

    printf "%d plugin/s uninstalled in %0.fs\n" $count $time > $stderr
end
