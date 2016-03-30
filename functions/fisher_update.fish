function fisher_update -d "Update plugins (u)"
    set -l items
    set -l plugins
    set -l enabled (fisher_list --enabled)
    set -l stdout /dev/stdout
    set -l stderr /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set items $items $2

            case q quiet
                set stdout /dev/null
                set stderr /dev/null

            case h
                printf "Usage: fisher update [<plugins>] [--quiet] [--help]\n\n"
                printf "    -q --quiet    Enable quiet mode\n"
                printf "    -h --help     Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option\n" $1 > /dev/stderr
                fisher_update -h > /dev/stderr
                return 1
        end
    end

    if set -l index (contains -i -- - $items)
        set -e items[$index]
        set -l IFS \t

        __fisher_file | while read -l item
            set items $items $item
        end

    else if test -z "$items"
        set -l time (date +%s)
        set -l previous_version (cat $fisher_home/VERSION)

        debug "update %s" $fisher_cache/.index
        debug "update %s" $fisher_home

        if not spin "__fisher_index_update 0" --error=$stderr
            debug "update index fail"
        end

        if not spin "__fisher_path_update $fisher_home" --error=$stderr
            debug "update fisherman fail"

            printf "fisher: I couldn't update Fisherman\n\n" > $stderr
            return 1
        end

        debug "update fisherman ok"

        set -l new_version (cat $fisher_home/VERSION)

        if test "$new_version" != "$previous_version"
            printf "Aye! Fisherman updated from %s to %s (%0.fs)\n" \
                "$previous_version" "$new_version" (math (date +%s) - $time) > $stderr
         else
            printf "Aye! Fisherman is up to date\n" $time > $stderr
        end

        set items $enabled
    end

    for item in $items
        if not contains -- $item $enabled
            printf "fisher: I couldn't find '%s'\n" $item > $stderr
            continue
        end

        if not set item (__fisher_plugin_validate $item)
            printf "fisher: '%s' is not a valid plugin\n" $item > $stderr
            debug "validate fail %s" $item
            continue
        end

        set -l path (__fisher_path_from_plugin $item)

        if test -z "$path"
            printf "fisher: I could not find '%s'\n" $item > $stderr
            continue
        end

        set plugins $plugins $path
        debug "validate ok %s" $item
    end

    set -l time (date +%s)
    set -l total (count $plugins)
    set -U fisher_updated_plugins

    if set -q plugins[1]
        if test "$total" -gt 0
            printf "Updating %d plugin/s\n" $total > $stderr
        end

        for path in $plugins
            set -l name (printf "%s\n" $path | __fisher_name)

            if test ! -L $path
                debug "update %s" "$name"

                fish -ic "
                    spin '
                        if set -l ahead (__fisher_path_update $path)
                            set fisher_updated_plugins \$fisher_updated_plugins $name
                            printf \"    %-22s    %-10s\n\" \"$name\" \"\$ahead new commit/s\"
                        else
                            printf \"    %-22s    %-10s\n\" \"$name\" \"Up to date\"
                        end

                    '
                " &
            end
        end

        while true
            set -l has_jobs (jobs)
            if test -z "$has_jobs"
                break
            end
        end

        for plugin in $fisher_updated_plugins
            set -l path (__fisher_path_from_plugin "$plugin")

            if __fisher_plugin_can_enable "$plugin" "$path"
                __fisher_plugin_enable "$plugin" "$path"
                debug "enable %s" "$plugin"
            end
        end

        if test -z "$fisher_updated_plugins"
            printf "No plugins were updated\n" > $stdout
            set -e fisher_updated_plugins
            return
        end
    end

    set time (math (date +%s) - $time)

    if test ! -z "$fisher_updated_plugins" -a "$fisher_updated_plugins" -ne 0
        printf "%d plugin/s up to date (%0.fs)\n" (count $fisher_updated_plugins) $time > $stdout

        set -e fisher_updated_plugins

        __fisher_complete_reset
        __fisher_key_bindings_reset

        debug "complete and key binds reset"
    end
end
