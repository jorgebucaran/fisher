function fisher -d "Fish Shell Plugin Manager"
    if not set -q argv[1]
        fisher --help
        return 1
    end

    set -l option
    set -l value
    set -l quiet -E .
    set -l alias

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set option command
                set value $2
                break

            case a alias
                set option alias
                set alias $alias $2

            case h help
                set option help
                set value $value $2

            case l list
                set option list

            case c cache
                set option cache

            case f file
                set option file
                set value $2

            case V validate
                set option validate

            case name
                set option translate

            case v version
                set option version

            case q quiet
                set quiet -q .

            case \*
                printf "fisher: Ahoy! '%s' is not a valid option\n" $1 >& 2
                fisher --help >& 2
                return 1
        end
    end

    switch "$option"
        case command
            __fisher_alias | while read -la alias
                if set -q alias[2]
                    switch "$value"
                        case $alias[2..-1]
                            set value $alias[1]
                            break
                    end
                end
            end

            if not functions -q "fisher_$value"
                printf "fisher: '%s' is not a valid command\n" "$value" >& 2
                fisher --help >& 2 | head -n1 >& 2
                return 1
            end

            set -e argv[1]

            if not eval "fisher_$value" (printf "%s\n" "'"$argv"'")
                return 1
            end

        case validate
            __fisher_validate | grep $quiet

        case list
            __fisher_list

        case cache
            __fisher_cache

        case file
            __fisher_file "$value"

        case alias
            __fisher_alias $alias

        case name
            __fisher_name

        case version
            sed 's/^/fisher version /;q' $fisher_home/VERSION

        case help
            if test -z "$value"
                set value commands
            end

            printf "usage: fisher [--version] [--help] [--list] [--quiet]\n"
            printf "              [-a <command>=alias[,...]] [-f <path>]\n"
            printf "              <command> [<options>]\n\n"

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
