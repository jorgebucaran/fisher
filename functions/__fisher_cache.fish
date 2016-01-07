function __fisher_cache -d "Calculate path of a name, url or path relative to the cache"
    while read --prompt="" -l item
        switch "$item"
            case file:///\*
                printf "%s\n" $item

            case \*/\*
                for file in $fisher_cache/*
                    switch "$item"
                        case (git -C $file ls-remote --get-url | __fisher_validate)
                            printf "%s\n" $file
                            break
                    end
                end

            case \*
                printf "%s\n" $fisher_cache/$item
        end
    end
end
