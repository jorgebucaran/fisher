function fisher_update -d "Update Plugins/Fisherman"
    set -l plugins
    set -l option self
    set -l error /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case - _
                set option
                set plugins $plugins $2

            case q quiet
                set error /dev/null

            case h
                printf "usage: fisher update [<plugins>] [--quiet] [--help]\n\n"
                printf "    -q --quiet  Enable quiet mode\n"
                printf "     -h --help  Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 >& 2
                fisher_update -h >& 2
                return 1
        end
    end

    switch "$option"
        case self
            set -l time (date +%s)

            printf "Updating >> Fisherman\n" > $error

            if not wait "__fisher_index_update; __fisher_path_update $fisher_home"
                printf "fisher: Arrr! Could not update Fisherman.\n" > $error
                sed -E 's/.*error: (.*)/\1/' $fisher_cache/.debug > $error
                return 1
            end

            #############################
            ## Remove before 1.0
            set -g fisher_file $fisher_config/fishfile
            if test ! -e $fisher_file
                touch $fisher_file
            end
            ## Remove before 1.0
            #############################

            printf "Aye! Fisherman updated to version %s (%0.fs)\n" (
                cat $fisher_home/VERSION) (math (date +%s) - $time) > $error

        case \*
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
                    printf "fisher: '%s' is not a valid name, path or url.\n" $item > $error
                    continue
                end

                if not set path (__fisher_path_from_plugin $item)
                    set total (math $total - 1)
                    printf "fisher: '%s' not found.\n" $item > $error
                    continue
                end

                set -l name (printf "%s\n" $path | __fisher_name)

                printf "Updating " > $error

                switch $total
                    case 0 1
                        printf ">> %s\n" $name > $error

                    case \*
                        printf "(%s of %s) >> %s\n" $index $total $name > $error
                        set index (math $index + 1)
                end

                if not wait "__fisher_path_update $path"
                    if test ! -L $path
                        sed -nE 's/.*(error|fatal): (.*)/error: \2/p
                            ' $fisher_cache/.debug > $error
                        continue
                    end
                end

                fisher_install --quiet --force -- $name

                set count (math $count + 1)
            end

            set time (math (date +%s) - $time)

            if test $count -le 0
                printf "No plugins were updated.\n" > $error
                return 1
            end

            printf "Aye! %d plugin/s updated in %0.fs\n" > $error $count $time
    end
end
