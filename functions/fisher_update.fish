function fisher_update -d "Update Fisherman or Plugins"
    set -l path
    set -l items
    set -l option self
    set -l error /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case - _
                set option
                set items $items $2

            case index
                set option index

            case path
                set option path
                set path $2

            case q quiet
                set error $2

            case help
                set option help

            case h
                printf "usage: fisher update [<plugins>] [--quiet] [--help]\n\n"

                printf "    -q --quiet  Enable quiet mode\n"
                printf "     -h --help  Show usage help \n"
                return

            case \*
                printf "fisher: Ahoy! '%s' is not a valid option\n" $1 >& 2
                fisher_update -h >& 2
                return 1
        end
    end

    switch "$option"
        case help
            fisher help update
            return
    end

    if test -z "$error"
        set error /dev/null
    end

    switch "$option"
        case path
            if not test -d $path
                printf "fisher: '%s' invalid path\n" $path > $error
                return 1
            end

            wait --spin=pipe --log=$fisher_error_log "

                git -C $path checkout --quiet master ^/dev/null
                git -C $path pull --quiet --rebase origin master

                "

        case index
            mkdir -p $fisher_cache
            set -l index $fisher_cache/.index.tmp

            if not set -q fisher_timeout
                set fisher_timeout 5
            end

            if wait --spin=pipe --log=$fisher_error_log "
                curl --max-time $fisher_timeout -sS $fisher_index > $index
            "
                mv -f $index $fisher_cache/.index
            else
                printf "fisher: Connection timeout. Try again.\n" > $error
            end

            rm -f $index

        case self
            set -l time (date +%s)

            printf "Updating >> Fisherman\n" > $error

            if not fisher_update --path=$fisher_home --quiet=$error
                printf "fisher: Arrr! Could not update Fisherman.\n" > $error
                sed -E 's/.*error: (.*)/\1/' $fisher_error_log > $error
                return 1
            end

            printf "Done without errors (%0.fs)\n" (math (date +%s) - $time) > $error

        case \*
            set -l time (date +%s)
            set -l count 0
            set -l index 1
            set -l total (count $items)

            if set -q items[1]
                printf "%s\n" $items
            else
                __fisher_file /dev/stdin

            end | __fisher_validate | __fisher_resolve_plugin $error | while read -l path

                set -l name (printf "%s\n" $path | __fisher_name)

                printf "Updating " > $error

                switch $total
                    case 0 1
                        printf ">> %s\n" $name > $error

                    case \*
                        printf "(%s of %s) >> %s\n" $index $total $name > $error
                        set index (math $index + 1)
                end

                if not fisher_update --path=$path --quiet
                    if test ! -L $path
                        sed -nE 's/.*(error|fatal): (.*)/error: \2/p
                            ' $fisher_error_log > $error
                        continue
                    end
                end

                fisher install --quiet -- $name

                set count (math $count + 1)
            end

            set time (math (date +%s) - $time)

            if test $count = 0
                printf "No plugins were updated.\n" > $error
                return 1
            end

            printf "Aye! %d plugin/s updated in %0.fs\n" > $error $count $time
    end
end
