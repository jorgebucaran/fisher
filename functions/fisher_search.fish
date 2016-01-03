function fisher_search -d "Search Fisherman Index"
    set -l select all
    set -l fields
    set -l join "||"
    set -l query
    set -l quiet 0
    set -l index

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

            case index
                set index $2

            case q quiet
                set quiet 1

            case h help
                printf "usage: fisher search [<name or url>] [--select=<source>] [--field=<field>]\n"
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

    if test -z "$fields[1]"
        set fields '$0'
    end

    set fields (printf "%s\n" $fields | paste -sd, -)
    set query (printf "%s\n" $query | sed -E 's/^[\|&]+//')

    switch "$select"
        case all
            if test -z "$index"
                set index $fisher_cache/.index

                if test -s $fisher_index
                    set index $fisher_index
                else
                    fisher_update --quiet --index
                end
            end

            if not test -s $index
                printf "fisher: '%s' invalid path or url\n" $index >& 2
                return 1
            end

            set -l cache (fisher --cache=base)
            awk -v FS='\n' -v RS='' -v cache_items="$cache" '

            BEGIN {
                split(cache_items, cache, " ")
            }

            /^ *#/ { next } {
                for (i in cache) {
                    if (cache[i] == $1) {
                        delete cache[i]
                    }
                }
            }

            END {
                for (i in cache) {
                    printf("%s\n", cache[i])
                }
            }

            ' $index | while read -l orphan
                git -C $fisher_cache/$orphan ls-remote --get-url \
                    | read -l url

                printf "%s\n" $url \
                    | sed -E '
                        s|^https?://||
                        s|^github\.com||
                        s|^bitbucket.org|bb:|
                        s|^gitlab.com|gl:|
                        s|^/||' \
                    | read -l info

                git -C $fisher_cache/$orphan show -s --format='%ae;%an' (
                    git -C $fisher_cache/$orphan rev-list --max-parents=0 HEAD) \
                    | awk -v FS=';' '{ printf("%s\n", ($1 ? $1 : $2 ? $2 : "unknown")) }' \
                    | read -l author

                set -l tags orphan

                for tag in theme plugin oh-my-fish config
                    if printf "%s" "$url" | grep -q $tag
                        switch "$tag"
                            case oh-my-fish
                                set tag omf
                        end
                        set tags $tag $tags
                    end
                end

                printf "\n%s\n%s\n%s\n%s\n%s\n\n" "$orphan" "$url" "$info" "$tags" "$author"
            end

            cat $index

        case remote
            fisher_search --index=$index --and --name!=(fisher --cache=base)

        case cache
            fisher --cache=base | read -laz cache

            if test -z "$cache"
                return 1
            end

            fisher_search --index=$index --select=all --name=$cache

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
  " | sed '${/^$/d;}' | awk -v quiet=$quiet '
      !/^ *$/ { notEmpty = 1 }
      !quiet { print }
      quiet && !notEmpty { exit !notEmpty }
      END { exit !notEmpty }
  '
end
