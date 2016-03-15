function fisher_update -d "Update plugins"
    set -l items
    set -l stdout /dev/stdout
    set -l stderr /dev/stderr
    set -l indicator "▸"
    set -l color (set_color $fish_color_match)
    set -l color_normal (set_color normal)

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

        printf "$indicator Updating Fisherman\n" > $stderr
        debug "Update %s" $fisher_cache/.index
        debug "Update %s" $fisher_home

        if not spin "__fisher_index_update 0" --error=$stderr -f "  $color@$color_normal\r"
            debug "Update Index fail"
        end

        if not spin "__fisher_path_update $fisher_home" --error=$stderr -f "  $color@$color_normal\r"
            debug "Update Fisherman fail"

            printf "fisher: I couldn't update Fisherman.\n\n" > $stderr
            return 1
        end

        debug "Update Fisherman ok"

        printf "Aye! Fisherman %s updated (%0.fs)\n" (
            cat $fisher_home/VERSION) (math (date +%s) - $time) > $stderr

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

    printf "Updating plugins...\n" $name > $stderr

    for path in $plugins
        set -l name (printf "%s\n" $path | __fisher_name)

        if test ! -L $path
            debug "Update start %s" "$name"
            fish -ic "
                spin '
                    if __fisher_path_update $path
                        set fisher_updated_plugins \$fisher_updated_plugins $name
                        printf \"%s\n\" \"$indicator $name\"
                    end

                ' -f \"  $color@$color_normal\r\"
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
        set -l path (__fisher_path_from_plugin)
        if __fisher_plugin_can_enable "$plugin" "$path"
            debug "Enable %s" "$plugin"
            __fisher_plugin_enable "$plugin" "$path"
        end
    end

    set time (math (date +%s) - $time)

    if test -z "$fisher_updated_plugins"
        printf "No plugins were updated.\n" > $stdout
        set -e fisher_updated_plugins
        return 1
    end

    printf "%d plugin/s updated in %0.fs\n" (count $fisher_updated_plugins) $time > $stdout
    set -e fisher_updated_plugins

    debug "Reset completions and key bindings start"

    __fisher_complete_reset
    __fisher_key_bindings_reset

    debug "Reset completions and key bindings ok"
end
