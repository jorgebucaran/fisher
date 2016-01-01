function fisher_update -d "Fisherman Update Manager"
    set -l option
    set -l path
    set -l items
    set -l error /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set items $items $2

            case index
                set option $option index

            case s {,it,my,one}self fisher{,man}
                set option $option self

            case c cache
                set option $option cache

            case path
                set option path
                set path $2

            case q quiet
                if test -z "$2"
                    set 2 /dev/null
                end
                set error $2

            case help h
                printf "usage: fisher update [<name | url> ...] [--self] [--cache]\n"
                printf "                     [--path=<path>] [--quiet] [--help]\n\n"

                printf "        -s --self  Update Fisherman                  \n"
                printf "       -c --cache  Update cached plugins             \n"
                printf "    --path=<path>  Update repository at given path   \n"
                printf "       -q --quiet  Enable quiet mode                 \n"
                printf "        -h --help  Show usage help                   \n"
                return

            case \*
                printf "fisher: '%s' is not a valid option\n" $1 >& 2
                fisher_update --help >& 2
                return 1
        end
    end

    switch path
        case $option
            if not test -d $path
                printf "fisher: '%s' invalid path\n" $path > $error
                return 1
            end

            wait --spin=pipe --log=$fisher_error_log "
                git -C $path checkout --quiet master ^/dev/null
                git -C $path pull --quiet --rebase origin master"

            return
    end

    switch index
        case $option
            mkdir -p $fisher_cache
            set -l index $fisher_cache/.(random)

            if not wait --spin=pipe --log=$fisher_error_log "curl -sS $fisher_index > $index"
                rm -f $index
                cat $fisher_error_log > $error

                return 1
            end

            mv -f $index $fisher_cache/.index
    end

    switch self
        case $option
            set -l elap (date +%s)

            printf "Updating >> Fisherman\n" > $error

            if not fisher_update --path=$fisher_home --quiet=$error
                return 1
            end

            printf "Done without errors (%0.fs)\n" (math (date +%s) - $elap) > $error
    end

    set -l elap (date +%s)
    set -l count 0
    set -l total (count $items)

    switch cache
        case $option
            set -l cache (find $fisher_cache/* -maxdepth 0 -type d)
            set total (count $cache)
            printf "%s\n" $cache

        case \*
            if set -q items[1]
                printf "%s\n" $items
            else

                if contains -- $option self
                    return
                end

                if contains -- $option index
                    return
                end

                fisher --file=-
            end | fisher --validate | fisher --path-in-cache

    end | while read -l path

        if not test -d "$path"
            printf "fisher: '%s' not found\n" $path > $error
            continue
        end

        set -l name (basename $path)

        printf "Updating " > $error

        switch $total
            case 0 1
                printf ">> %s\n" $name > $error

            case \*
                printf "(%s of %s) >> %s\n" (math 1 + $count) $total $name > $error
        end

        if not fisher_update --path=$path --quiet=$error
            sed -nE 's/.*(error|fatal): (.*)/error: \2/p' $fisher_error_log > $error
            continue
        end

        fisher install $name --quiet

        set count (math $count + 1)
    end

    printf "%d plugin/s updated (%0.fs)\n" $count (math (date +%s) - $elap) > $error
    
    test $count -gt 0
end
