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
            set -l IFS =
            set -l default_alias install=i update=u search=s list=l help=h new=n

            printf "%s\n" $fisher_alias $default_alias | while read -l command alias
                if test "$value" = "$alias"
                    set value "$command"
                    break
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
            printf "Usage: fisher <command> [<options>] [--help] [--version]\n\n"

            set -l color (set_color -u)
            set -l color_normal (set_color normal)

            printf "Commands:\n"

            __fisher_help_commands | sed "

                s/^/    /
                s/;/"\t"  /

            " | column -ts\t | sed -E "
                s/^    (h)(elp)/    $color\1$color_normal\2/
                s/^    (i)(nstall)/    $color\1$color_normal\2/
                s/^    (s)(earch)/    $color\1$color_normal\2/
                s/^    (u)(pdate)/    $color\1$color_normal\2/
                s/^    (l)(ist)/    $color\1$color_normal\2/
                s/^    (n)(ew)/    $color\1$color_normal\2/
            "

            printf "\nUse fisher help <command> to get help.\n"
    end
end
