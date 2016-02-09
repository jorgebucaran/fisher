function fisher_help -d "Show Help"
    if not set -q argv[1]
        man fisher
        return
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

            case help
                set option help

            case h
                printf "usage: fisher help [<keyword>] [--all] [--guides] [--help]\n\n"

                printf "              -a --all  List available documentation\n"
                printf "           -g --guides  List available guides\n"
                printf "    -u --usage[=<cmd>]  Display command usage\n"
                printf "             -h --help  Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_help --help > /dev/stderr
                return 1
        end
    end

    if not set -q option[1]
        set option commands
    end

    switch "$option"
        case help
            man fisher-help

        case manual
            set -l value (printf "%s\n" $value | awk '{ print tolower($0) }')

            switch "$value"
                case me fisher fisherman
                    man fisher

                case \*
                    man fisher-$value
            end

        case usage
            if test -z "$value"
                set -e value
                sed -E 's/^ *([^ ]+).*/\1/' | while read -l command
                    if functions -q fisher_$command
                        set value $command $value
                    end
                end
            end

            for command in $value
                fisher $command -h
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
                    functions -a | grep '^fisher_[^_]*$' | while read -l func
                        functions $func | awk '
                            /^$/ { next } {
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
