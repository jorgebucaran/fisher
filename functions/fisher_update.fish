function fisher_update -d "Update plugins"
    set -l items
    set -l plugins
    set -l stdout /dev/stdout
    set -l stderr /dev/stderr
    set -l indicator "▸"

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
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
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

        printf "$indicator Updating Fisherman" > $stderr
        debug "Update %s" $fisher_cache/.index
        debug "Update %s" $fisher_home

        if not spin "__fisher_index_update 0" --error=$stderr
            debug "Update index fail"
        end

        if not spin "__fisher_path_update $fisher_home" --error=$stderr
            debug "Update Fisherman fail"

            printf "\nfisher: I couldn't update Fisherman.\n\n" > $stderr
            return 1
        end

        debug "Update Fisherman ok"

        set -l new_version (cat $fisher_home/VERSION)

        if test "$new_version" != "$previous_version"
            printf "        Updated from %s to %s in %0.fs\n" \
                "$previous_version" "$new_version" (math (date +%s) - $time) > $stderr
         else
            printf "        Up to date\n" $time > $stderr
        end

        set items (fisher_list --enabled)
    end

    for item in $items
        debug "Validate %s" $item

        if not set item (__fisher_plugin_validate $item)
            debug "Validate fail %s" $item
            printf "fisher: '%s' is not a valid name, path or URL.\n" $item > $stderr
            continue
        end

        set -l path (__fisher_path_from_plugin $item)

        if test -z "$path"
            printf "fisher: Plugin '%s' is not installed.\n" $item > $stderr
            continue
        end

        debug "Validate ok %s" $item

        set plugins $plugins $path
    end

    set -l time (date +%s)
    set -l total (count $plugins)
    set -U fisher_updated_plugins

    if set -q plugins[1]
        if test "$total" -gt 0
            printf "$indicator Updating %d plugin/s...\n" $total > $stderr
        end

        for path in $plugins
            set -l name (printf "%s\n" $path | __fisher_name)

            if test ! -L $path
                debug "Update start %s" "$name"
                fish -ic "
                    spin '
                        if set -l ahead (__fisher_path_update $path)
                            set fisher_updated_plugins \$fisher_updated_plugins $name
                            printf \"  %-22s    %-10s\n\" \"$name\" \"\$ahead new commit/s\"
                        else
                            printf \"  %-22s    %-10s\n\" \"$name\" \"Up to date\"
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
                debug "Enable %s" "$plugin"
                __fisher_plugin_enable "$plugin" "$path"
            end
        end

        if test -z "$fisher_updated_plugins"
            printf "No plugins were updated\n" > $stdout
            set -e fisher_updated_plugins
            return 1
        end
    end

    set time (math (date +%s) - $time)

    printf "%d plugin/s updated in %0.fs\n" (count $fisher_updated_plugins) $time > $stdout
    set -e fisher_updated_plugins

    debug "Reset completions and key bindings start"

    __fisher_complete_reset
    __fisher_key_bindings_reset

    debug "Reset completions and key bindings ok"
end
