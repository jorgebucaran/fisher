function fisher -d "Fish Plugin Manager"
    set -l value
    set -l option help

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set option command
                set value $2
                break

            case h help
                set option help
                set value $value $2

            case l list
                set option list
                set value $2

            case v version
                set option version

            case \*
                if test ! -z "$option"
                    continue
                end

                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher -h > /dev/stderr
                return 1
        end
    end

    switch "$option"
        case command
            printf "%s\n" $fisher_alias | sed 's/[=,]/ /g' | while read -la alias
                if set -q alias[2]
                    switch "$value"
                        case $alias[2..-1]
                            set value $alias[1]
                            break
                    end
                end
            end

            if not functions -q "fisher_$value"
                printf "fisher: '%s' is not a valid command\n" "$value" > /dev/stderr
                fisher --help > /dev/stderr
                return 1
            end

            if contains -- --help $argv
                fisher help $value
                return
            end

            set -e argv[1]

            eval "fisher_$value" (printf "%s\n" "'"$argv"'")

        case list
            __fisher_list $value

        case version
            sed 's/^/fisher version /;q' $fisher_home/VERSION

        case help
            if test -z "$value"
                set value commands
            end

            printf "Usage: fisher <command> [<args>] [--list] [--version]\n\n"

            switch commands
                case $value
                    printf "Available Commands:\n"
                    fisher_help --commands=bare
                    echo
            end

            switch guides
                case $value
                    printf "Other Documentation:\n"
                    fisher_help --guides=bare
                    echo
            end

            printf "Use 'fisher help -g' to list guides and other documentation.\n"
            printf "See 'fisher help <command or concept>' to access a man page.\n"
    end
end
