function fisher_help -d "Show help"
    if not set -q argv[1]
        man fisher
        return
    end

    set -l option
    set -l value

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set option man
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

            case usage
                set option usage
                set value $value $2

            case h
                printf "Usage: fisher help [<keyword>] [--all] [--guides] [--help]\n\n"
                printf "    -a --all       List all the documentation\n"
                printf "    -g --guides    List available guides\n"
                printf "    -h --help      Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_help -h > /dev/stderr
                return 1
        end
    end

    if not set -q option[1]
        set option commands
    end

    switch "$option"
        case man
            set -l value (printf "%s\n" $value | awk '{ print tolower($0) }')

            switch "$value"
                case me fisher fisherman
                    man fisher

                case \*
                    man fisher-$value
            end

        case usage
            __fisher_help_usage $value

        case \*
            if test "$value" != bare
                fisher --help=$option
                return
            end

            begin
                if contains -- commands $option
                    __fisher_help_commands
                end

                if contains -- guides $option
                    __fisher_help_guides
                end
            end | sed 's/^/  /;s/;/'\t'/' | column -ts\t
    end
end
