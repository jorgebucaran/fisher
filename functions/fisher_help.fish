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

            case usage
                set option usage
                set value $value $2

            case h
                printf "Usage: fisher help [<keyword>]\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_help -h > /dev/stderr
                return 1
        end
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
    end
end
