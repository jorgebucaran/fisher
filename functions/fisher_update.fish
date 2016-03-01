function fisher_update -d "Update plugins"
    set -l plugins
    set -l option self
    set -l stdout /dev/stdout
    set -l stderr /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set option

                if test "$2" != -
                    set plugins $plugins $2
                end

            case a all
                set option all

            case q quiet
                set stdout /dev/null
                set stderr /dev/null

            case h
                printf "Usage: fisher update [<plugins>] [--all] [--quiet] [--help]\n\n"
                printf "    -a --all      Update everything\n"
                printf "    -q --quiet    Enable quiet mode\n"
                printf "    -h --help     Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_update -h > /dev/stderr
                return 1
        end
    end

    set -l indicator "▸"

    switch "$option"
        case all
            fisher_list --enabled | fisher_update -
            fisher_update

        case self
            set -l time (date +%s)

            debug "Update %s" $fisher_index
            debug "Update %s" $fisher_home

            printf "$indicator Updating Index\n" > $stderr

            if not spin "__fisher_index_update 0" --error=$stderr -f "  @\r"
                debug "Update Index fail"

                printf "fisher: I could not update the index.\n" > $stderr
            end

            printf "$indicator Updating Fisherman\n" > $stderr

            if not spin "__fisher_path_update $fisher_home" --error=$stderr  -f "  @\r"
                debug "Update Fisherman fail"

                printf "fisher: Sorry, but I couldn't update Fisherman.\n\n" > $stderr
                return 1
            end

            debug "Update Fisherman ok"

            printf "Aye! Fisherman up to date with version %s (%0.fs)\n" (
                cat $fisher_home/VERSION) (math (date +%s) - $time) > $stderr

        case \*
            set -l time (date +%s)
            set -l count 0
            set -l index 1
            set -l total (count $plugins)
            set -l skipped

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
                    printf "fisher: '%s' not found.\n" $item > $stderr
                    continue
                end

                set -l name (printf "%s\n" $path | __fisher_name)

                printf "$indicator Updating " > $stderr

                switch $total
                    case 0 1
                        printf "%s\n" $name > $stderr

                    case \*
                        printf "(%s of %s) %s\n" $index $total $name > $stderr
                        set index (math $index + 1)
                end

                if test ! -L $path
                    debug "Update start %s" "$name"

                    if not spin "__fisher_path_update $path" --error=$stderr -f "  @\r"
                        debug "Update fail %s" "$path"
                        continue
                    end
                end

                debug "Update ok %s" "$name"

                if __fisher_plugin_can_enable "$name" "$path"
                    debug "Enable %s" "$name"

                    fisher_install --quiet --force -- $name
                end

                set count (math $count + 1)
            end

            set time (math (date +%s) - $time)

            if test $count -le 0
                printf "No plugins were updated.\n" > $stdout
                return 1
            end

            printf "%d plugin/s updated in %0.fs\n" $count $time > $stdout
    end
end
