function fisher_list -a key -d "List installed plugins"
    set -l enabled

    if test -s "$fisher_file"
        set enabled (__fisher_list < $fisher_file)
    end

    switch "$key"
        case ""
            set -l cache (__fisher_cache_list)

            if test -z "$cache"
                return 1
            end

            set -l indent " "

            if test -z "$enabled"
                set indent ""
            end

            for i in $cache
                if contains -- $i $enabled
                    if test $i = "$fisher_prompt"
                        printf "%s%s\n" ">$indent" $i

                    else if test -L $fisher_cache/$i

                        printf "%s%s\n" "@$indent" $i

                    else
                        printf "%s%s\n" "*$indent" $i
                    end
                else
                    printf "%s%s\n" "$indent$indent" $i
                end
            end

        case -l --link
            find $fisher_cache/* -maxdepth 0 -type l ^ /dev/null | sed 's|.*/||'

        case --enabled
            printf "%s\n" $enabled

        case --disabled
            for name in (__fisher_cache_list)
                if not contains -- $name $enabled
                    printf "%s\n" $name
                end
            end

        case -
            __fisher_list

        case -h
            printf "Usage: fisher list [--enabled] [--disabled] [--link]\n\n"
            printf "    -l --link        List plugins that are symbolic links\n"
            printf "       --enabled     List plugins that are enabled\n"
            printf "       --disabled    List plugins that are disabled\n"
            printf "    -h --help        Show usage help\n"
            return
    end
end
