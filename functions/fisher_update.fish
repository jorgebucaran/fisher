function fisher_update -d "Update Plugins/Fisherman"
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

            case q quiet
                set stdout /dev/null
                set stderr /dev/null

            case h
                printf "Usage: fisher update [<plugins>] [--quiet] [--help]\n\n"
                printf "    -q --quiet  Enable quiet mode\n"
                printf "     -h --help  Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_update -h > /dev/stderr
                return 1
        end
    end

    switch "$option"
        case self
            set -l time (date +%s)

            printf "Updating >> Fisherman\n" > $stderr

            if not spin "
                __fisher_index_update 0
                __fisher_path_update $fisher_home" --error=$stderr

                ###
                ###

                printf "fisher: Arrr! Could not update Fisherman.\n" > $stderr
                return 1
            end

            printf "Aye! Fisherman updated to version %s (%0.fs)\n" (
                cat $fisher_home/VERSION) (math (date +%s) - $time) > $stderr

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
                    printf "fisher: '%s' is not a valid name, path or url.\n" $item > $stderr
                    continue
                end

                if not set path (__fisher_path_from_plugin $item)
                    set total (math $total - 1)
                    printf "fisher: '%s' not found.\n" $item > $stderr
                    continue
                end

                set -l name (printf "%s\n" $path | __fisher_name)

                printf "Updating " > $stderr

                switch $total
                    case 0 1
                        printf ">> %s\n" $name > $stderr

                    case \*
                        printf "(%s of %s) >> %s\n" $index $total $name > $stderr
                        set index (math $index + 1)
                end

                if test ! -L $path
                    if not spin "__fisher_path_update $path" --error=$stderr
                        continue
                    end
                end

                if __fisher_plugin_can_enable "$name" "$path"
                    fisher_install --quiet --force -- $name
                end

                set count (math $count + 1)
            end

            set time (math (date +%s) - $time)

            if test $count -le 0
                printf "No plugins were updated.\n" > $stdout
                return 1
            end

            printf "Aye! %d plugin/s updated in %0.fs\n" $count $time > $stdout
    end
end
