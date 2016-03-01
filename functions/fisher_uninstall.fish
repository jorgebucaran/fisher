function fisher_uninstall -d "Uninstall plugins"
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
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_uninstall -h > /dev/stderr
                return 1
        end
    end

    set -l time (date +%s)
    set -l count 0
    set -l index 1
    set -l total (count $plugins)
    set -l skipped
    set -l indicator "▸"

    set -l IFS \t

    if set -q plugins[1]
        printf "%s\n" $plugins
    else
        __fisher_file
        
    end | while read -l item path
        debug "Validate %s" $item

        if not set item (__fisher_plugin_validate $item)
            debug "Validate fail %s" $item
            printf "fisher: '%s' is not a valid name, path or URL.\n" $item > $stderr
            continue
        end

        debug "Validate ok %s" $item

        if not set path (__fisher_path_from_plugin $item)
            set total (math $total - 1)
            printf "fisher: '%s' not found\n" $item > $stderr
            continue
        end

        set -l name (printf "%s\n" $path | __fisher_name)

        debug "Uninstall %s" "$name"

        if not contains -- $name (fisher_list $fisher_file)
            if test -z "$option"
                set total (math $total - 1)
                set skipped $skipped $name
                continue
            end
        end

        printf "$indicator Uninstalling " > $stderr

        switch $total
            case 0 1
                printf "%s\n" $name > $stderr

            case \*
                printf "(%s of %s) %s\n" $index $total $name > $stderr
                set index (math $index + 1)
        end

        if __fisher_plugin_can_enable "$name" "$path"
            debug "Disable %s[:%s]" "$name" "$option"
            __fisher_plugin_disable "$name" "$path" "$option"
        else
            debug "Disable skip %s" "$name"
        end

        if test "$option" = force
            debug "Delete %s" "$path"
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

    debug "Reset completions and key bindings start"

    __fisher_complete_reset
    __fisher_key_bindings_reset

    debug "Reset completions and key bindings ok"

    printf "%d plugin/s uninstalled in %0.fs\n" $count $time > $stdout
end
