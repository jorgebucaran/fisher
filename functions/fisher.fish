function fisher -d "Fish Shell Manager"
    if not set -q argv[1]
        fisher --help
        return 1
    end

    set -l option
    set -l value
    set -l quiet -E .

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set option command
                set value $2
                break

            case h help
                set option help
                set value $value $2

            case path-in-cache
                set option path-in-cache
                set value $2

            case f file
                set option file
                set value $2

            case V validate
                set option validate
                set value $2

            case v version
                set option version

            case q quiet
                set quiet -q .

            case \*
                printf "fisher: '%s' is not a valid option\n" $1 >& 2
                fisher --help >& 2
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
                printf "fisher: '%s' is not a valid command\n" "$value" >& 2
                fisher --help >& 2 | head -n1 >& 2
                return 1
            end

            set -e argv[1]

            if not eval "fisher_$value" (printf "%s\n" "'"$argv"'")
                return 1
            end

        case validate
            if not test -z "$value"
                printf "%s\n" $value | fisher --validate | grep $quiet
                return
            end

            if not set -q fisher_default_host
                set fisher_default_host https://github.com
            end

            set -l id "[A-Za-z0-9_-]"

            sed -En "
                s#/\$##
                s#\.git\$##
                s#^(https?):*/* *(.*\$)#\1://\2#p
                s#^(@|(gh:)|(github(.com)?[/:]))/?($id+)/($id+)\$#https://github.com/\5/\6#p
                s#^(bb:)/?($id+)/($id+)\$#https://bitbucket.org/\2/\3#p
                s#^(gl:)/?($id+)/($id+)\$#https://gitlab.com/\2/\3#p
                s#^($id+)/($id+)\$#$fisher_default_host/\1/\2#p
                /^file:\/\/\/.*/p
                /^[a-z]+([._-]?[a-z0-9]+)*\$/p
                " | grep $quiet

        case path-in-cache
            while read --prompt= -l item
                switch "$item"
                    case \*/\*
                        for file in $fisher_cache/*
                            switch "$item"
                                case (git -C $file ls-remote --get-url | fisher --validate)
                                    printf "%s\n" $file
                                    break
                            end
                        end

                    case \*
                        printf "%s\n" $fisher_cache/$item
                end
            end

        case file
            switch "$value"
                case "-"
                    set value /dev/stdin
                case ""
                    set value $fisher_config/fishfile
            end

            awk  '
                !/^ *(#.*)*$/ {
                    gsub("#.*", "")

                    if (/^ *package .+/) {
                        $1 = $2
                    }

                    if (!k[$1]++) {
                        printf("%s\n", $1)
                    }
                }
            ' $value

        case version
            sed 's/^/fisher version /;q' $fisher_home/VERSION

        case help
            if test -z "$value"
                set value commands
            end

            printf "usage: fisher <command> [<options>] [--version] [--help]\n\n"

            switch commands
                case $value
                    printf "Available Fisherman commands:\n"
                    fisher_help --commands=bare
                    echo
            end

            switch guides
                case $value
                    printf "Available Fisherman guides:\n"
                    fisher_help --guides=bare
                    echo
            end

            printf "Use 'fisher help -g' to list guides and other documentation.\n"
            printf "See 'fisher help <command or concept>' to access a man page.\n"
    end
end
