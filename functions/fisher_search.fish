function fisher_search -d "Search Fisherman Index"
    set -l index $fisher_cache/.index

    set -l select all
    set -l fields
    set -l join "||"
    set -l query
    set -l quiet 0

    getopts $argv | while read -l 1 2 3
        switch "$1"
            case _ name url info author tag{,s}
                switch "$1"
                    case _
                        switch "$2"
                            case \*/\*
                                set 1 url

                                set -l url (fisher --validate=$2)
                                if not test -z "$url"
                                    set 2 $url
                                end

                            case \*
                                set 1 name
                        end

                    case tag{,s}
                        set 1 "find(tags, \"$2\")"
                        if test -z "$2"
                            set 1 "show(tags)"
                        end
                end

                switch "$2"
                    case ""
                        set fields $fields $1
                        continue

                    case {~,!~}\*
                        set 2 "$3$2"

                    case \?\*
                        if test "$3" = !
                            set 2 "!=\"$2\""
                        else
                            set 2 "==\"$2\""
                        end
                end

                set query "$query$join$1$2"

            case s select
                set select $2

            case f field{,s}
                switch "$2"
                    case T tag{,s}
                        set 2 "show(tags)"
                end
                set fields $fields $2

            case a and
                set join "&&"

            case o or
                set join "||"

            case Q query
                set query $query $2

            case q quiet
                set quiet 1

            case h help
                printf "usage: fisher search [<name | url>] [--select=<source>] [--field=<field>]\n"
                printf "                     [--or|--and] [--quiet] [--help]\n\n"

                printf "    -s --select=<source>  Select all, cache or remote plugins       \n"
                printf "      -f --field=<field>  Filter by name, url, info, tag or author  \n"
                printf "                -a --and  Join query with AND operator              \n"
                printf "                 -o --or  Join query with OR operator               \n"
                printf "              -q --quiet  Enable quiet mode                         \n"
                printf "               -h --help  Show usage help                           \n"
                return

            case \*
                printf "fisher: '%s' is not a valid option\n" $1 >& 2
                fisher_search --help >& 2
                return 1
        end
    end

    if not set -q fields[1]
        set fields '$0'
    end

    set fields (printf "%s\n" $fields | paste -sd, -)
    set query (printf "%s\n" $query | sed -E 's/^[\|&]+//')

    switch "$select"
        case all
            if not fisher_update --quiet --index
                if test -s $fisher_index
                    set index $fisher_index
                end
            end

            if not cat $index ^ /dev/null
                printf "fisher: '%s' invalid path or url\n" $index >& 2
                return 1
            end

        case remote
            fisher_search -a --name!=(
                fisher_search --field=name --select=cache)

        case cache
            set -l names (for file in $fisher_cache/*
                if test -d $file
                    basename $file
                end
            end)

            if test -z "$names"
                return 1
            end

            fisher_search --select=all --name=$names

    end | awk -F'\n' -v RS='' -v OFS=';' (
        if test "$fields" = '$0'
            printf "%s\nORS=%s" -v '\\n\\n'
        end) "

    function find(array, item) {
        for (i in array) {
            if (array[i] == item) {
                return item
            }
        }
    }

    function show(array) {
        for (i in array) {
            printf(\"%s \", array[i])
        }
    }

    /^ *#/ { next }

    {
        delete tags
        if (\$4) {
            split(\$4, tags, \" \")
        }

        name   = \$1
        url    = \$2
        info   = \$3
        author = \$5
    }

    $query {
        print $fields
    }
  " | sed '${/^$/d;}' | awk -v q=$quiet '
      !/^ *$/ { ret = 1 }
      !q { print }
      q && !ret { exit !ret }
      END { exit !ret }
  '
end
