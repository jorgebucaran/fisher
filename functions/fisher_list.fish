function fisher_list -a key -d "List installed plugins (l)"
    set -l enabled

    if test -f "$fisher_file"
        set enabled (__fisher_list < $fisher_file)
    end

    switch "$key"
        case ""
            set -l indent
            set -l links (command find $fisher_cache/* -maxdepth 0 -type l ^ /dev/null | sed 's|.*/||')

            if test ! -z "$fisher_prompt"
                set indent " "
            end

            for plugin in $links
                if contains -- "$plugin" $enabled
                    set indent " "
                    break
                end
            end

            for plugin in $enabled
                if contains -- "$plugin" $links
                    printf "%s %s\n" "@" $plugin

                else if test $plugin = "$fisher_prompt"
                    printf "%s %s\n" ">" $plugin

                else
                    printf "$indent$indent%s\n" $plugin
                end
            end

        case --enabled
            if test ! -z "$enabled"
                printf "%s\n" $enabled
            end

        case --disabled
            for name in (__fisher_cache_list)
                if not contains -- $name $enabled
                    printf "%s\n" $name
                end
            end

        case -
            __fisher_list

        case -h
            printf "Usage: fisher list [--enabled] [--disabled] [--help]\n\n"
            printf "       --enabled     List plugins that are enabled\n"
            printf "       --disabled    List plugins that are disabled\n"
            printf "    -h --help        Show usage help\n"
            return
    end
end
