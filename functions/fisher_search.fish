function fisher_search -d "Search Plugins"
    set -l fields
    set -l query
    set -l index
    set -l join "||"
    set -l quiet 0

    getopts $argv | while read -l 1 2 3
        switch "$1"
            case _
                switch "$2"
                    case \*/\*
                        set -l url (__fisher_plugin_validate $2)

                        if test ! -z "$url"
                            set 2 $url
                        end

                        set query $query "url==\"$2\"" $join

                    case \*
                        set query $query "name==\"$2\"" $join
                end

            case name url info author
                if test -z "$2"
                    set fields $fields $1 ,
                else
                    switch "$2"
                        case ~\*
                            set query $query "$1$3$2" $join

                        case \*
                            if test -z "$3"
                                set 3 =
                            end
                            set query $query "$1$3=\"$2\"" $join
                    end
                end

            case tag{,s}
                if test -z "$2"
                    set fields $fields "tags(0)" ,
                else
                    set query $query "$3 tags(\"$2\")" $join
                end

            case a and
                set join "&&"

            case o or
                set join "||"

            case query
                set query $query $2

            case index
                set index $2

            case q quiet
                set quiet 1

            case h
                printf "usage: fisher search [<plugins>] [--and|--or] [--quiet] [--help]\n\n"

                printf "    *--<field>  Filter by url, name, info, author or tags\n"
                printf "       -o --or  Join query with OR operator\n"
                printf "      -a --and  Join query with AND operator\n"
                printf "    -q --quiet  Enable quiet mode\n"
                printf "     -h --help  Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_search -h > /dev/stderr
                return 1
        end
    end

    if test -z "$index"
        set index $fisher_cache/.index

        set fisher_last_update (math (date +%s) - "0$fisher_last_update")

        if not set -q fisher_update_interval
            set -g fisher_update_interval 10
        end

        if test $fisher_last_update -gt $fisher_update_interval -o ! -f $index
            if spin "__fisher_index_update" --error=/dev/null
                __fisher_complete_reset
            end
        end

        set -U fisher_last_update (date +%s)
    end

    set -e fields[-1]
    set -e query[-1]

    if test -z "$fields[1]"
        set fields '$0'
    end

    awk -F'\n' -v RS='' -v OFS=';' (
        if test "$fields" = '$0'
            printf "%s\nORS=%s" -v '\\n\\n'
        end
        ) "

    function tags(tag, _list) {
        if (!tag) {
            for (i in tag_list) {
                if (!seen[tag_list[i]]++) {
                    _list = tag_list[i] \"\n\" _list
                }
            }
            return substr(_list, 1, length(_list) - 1)
        }
        for (i in tag_list) {
            if (tag == tag_list[i]) {
                return 1
            }
        }
        return 0
    }

    /^ *#/ { next } {
        delete tag_list
        if (\$4) split(\$4, tag_list, \" \")

        name   = \$1
        url    = \$2
        info   = \$3
        author = \$5
    }

    $query { print $fields } " $index | awk -v quiet=$quiet '

        !/^ *$/ { hasRecords = 1 } {
            if (quiet) {
                exit !hasRecords
            } else {
                records[NR] = $0
            }
        }

        END {
            for (i = 1; i <= NR; i++) {
                if (i == NR && records[i] ~ /^ *$/) {
                    break
                }
                print records[i]
            }

            exit !hasRecords
        }
    '
end
