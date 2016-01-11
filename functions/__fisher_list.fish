function __fisher_list -a category -d "list local plugins by category"
    set index $fisher_cache/.index

    switch "$category"
        case enabled installed on
            printf "%s\n" $fisher_plugins

        case \*
            for file in $fisher_cache/*
                set -l name (basename $file)

                switch "$category"
                    case disabled off
                        if not contains -- $name $fisher_plugins
                            printf "%s\n" $name
                        end

                    case \*
                        printf "%s\n" $name
                end
            end
    end
end
