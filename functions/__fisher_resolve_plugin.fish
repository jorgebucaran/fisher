function __fisher_resolve_plugin -a error -d "resolve path to a plugin"
    if test -z "$error"
        set error /dev/stderr
    end

    while read --prompt="" -l item
        switch "$item"
            case file:///\*
                for file in $fisher_cache/*
                    switch "$item"
                        case file://(readlink $file)
                            printf "%s\n" $file
                            break
                    end
                end

            case \*/\*
                for file in $fisher_cache/*
                    switch "$item"
                        case (git -C $file ls-remote --get-url | __fisher_validate)
                            printf "%s\n" $file
                            break
                    end
                end

            case \*
                set item $fisher_cache/$item
                if test -d "$item"
                    printf "%s\n" $item
                end

        end | read -l path

        if test -z "$path"
            printf "fisher: Avast! '%s' is not in the cache\n" $item > $error
            continue
        end

        printf "%s\n" $path
    end
end
