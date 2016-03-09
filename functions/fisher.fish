function fisher -d "Fish plugin manager"
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

            case v version
                set option version

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher -h > /dev/stderr
                return 1
        end
    end

    switch "$option"
        case command
            switch "$version"
                case 2.1.\* 2.0.0
                    if test ! -z "$fisher_alias"
                        printf "fisher: fish 2.2.0 or above is required to use aliases."
                    end

                case \*
                    if test -z "$fisher_alias"
                        set -g fisher_alias install=i update=u search=s list=l help=h
                    end

                    printf "%s\n" $fisher_alias | sed 's/[=,]/ /g' | while read -la alias
                        if set -q alias[2]
                            switch "$value"
                                case $alias[2..-1]
                                    set value $alias[1]
                                    break
                            end
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

        case version
            sed 's/^/fisher version /' $fisher_home/VERSION

        case help
            printf "Usage: fisher <command> [<arguments>] [--help] [--version]\n\n"

            set -l color (set_color $fish_color_command -u)
            set -l color_normal (set_color normal)

            printf "Available Commands:\n"

            fisher_help --commands=bare | sed -E "
                s/  (h)/  $color\1$color_normal/
                s/  (i)/  $color\1$color_normal/
                s/  (l)/  $color\1$color_normal/
                s/  (s)/  $color\1$color_normal/
                s/  (u)p/  $color\1$color_normal"p"/
                "

            printf "\nUse fisher help <command> to access a man page.\n"
    end
end
