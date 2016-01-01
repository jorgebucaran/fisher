function fisher_help -d "Display Help Information"
    if not set -q argv[1]
        fisher --help
        return 1
    end

    set -l option
    set -l value

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set option manual
                set value $2

            case a all
                set option guides commands
                set value $2

            case g guides
                set option $option guides
                set value $2

            case commands
                set option $option commands
                set value $2

            case u usage
                set option usage
                set value $value $2

            case h help
                printf "usage: fisher help [<keyword>] [--all] [--guides]\n"
                printf "                   [--usage[=<command>]] [--help]\n\n"

                printf "                  -a --all  List commands and guides   \n"
                printf "               -g --guides  List documentation guides  \n"
                printf "    -u --usage[=<command>]  Display command usage help \n"
                printf "                 -h --help  Show usage help            \n"
                return

            case \*
                printf "fisher: '%s' is not a valid option\n" $1 >& 2
                fisher_help --help >& 2
                return 1
        end
    end

    if not set -q option[1]
        set option commands
    end

    switch "$option"
        case manual
            switch "$value"
                case fisherman
                    man $value 7
                case fisher me @
                    man fisher
                case \*
                    man fisher-$value
            end

        case usage
            if test -z "$value"
                sed -E 's/^ *([^ ]+).*/\1/' | while read -l value
                    if functions -q fisher_$value
                        fisher $value --help
                    end
                end
            else
                printf "%s\n" $value | fisher_help --usage
            end

        case \*
            switch "$value"
                case bare
                case \*
                    fisher --help=$option
                    return
            end

            switch commands
                case $option
                        functions -a | grep '^fisher_[^_]*$' | while read -l f
                        functions $f | awk '
                            /^$/ { next }
                            {
                                printf("  %s\t", substr($2, 8))
                                gsub("\'","")

                                for (i=4; i<=NF && $i!~/^--.*/; i++) {
                                    printf("%s ", $i)
                                }

                                print ""
                                exit
                            }'
                    end | column -ts\t
            end

            switch guides
                case $option
                    sed -nE 's/(fisher-)?(.+)\([0-9]\) -- (.+)/  \2'\t'\3/p' \
                        {$fisher_home,$fisher_config}/man/man{5,7}/fisher*.md | sort -r

            end | column -ts\t
    end
end
