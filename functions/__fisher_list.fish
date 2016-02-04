function __fisher_list -a source
    switch "$source"
        case bare
            __fisher_cache_list

        case url
            for i in (__fisher_cache_list)
                __fisher_url_from_path $fisher_cache/$i
            end

        case "" all cache
            set -l enabled (__fisher_list $fisher_file)
            set -l legend " "

            if test -z "$enabled"
                set legend ""
            end

            for i in (__fisher_cache_list)
                if contains -- $i $enabled
                    if test -L $fisher_cache/$i
                        printf "%s%s\n" "|" $i

                    else if test $i = "$fisher_prompt"
                        printf "%s%s\n" ">" $i
                        
                    else
                        printf "%s%s\n" "*" $i
                    end
                else
                    printf "%s%s\n" "$legend" $i
                end
            end

        case enabled installed
            __fisher_list $fisher_file

        case disabled
            set -l enabled (__fisher_list $fisher_file)

            for name in (__fisher_cache_list)
                if not contains -- $name $enabled
                    printf "%s\n" $name
                end
            end

        case theme prompt
            printf "%s\n" $fisher_prompt

        case -
            __fisher_file | __fisher_name

        case \*
            if test -s "$source"
                __fisher_list - < $source
            end
    end
end
