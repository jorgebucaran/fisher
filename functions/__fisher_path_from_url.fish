function __fisher_path_from_url -a url

    # What is the difference between path-from-url and url-from-path?

    # Both functions use 'git ... --get-url'. The first one compares the given URL with
    # the ls-remote of each repo in the cache and returns the path of the first match.
    # The other one returns the ls-remote of the given path.

    for file in $fisher_cache/*
        switch "$url"
            case (git -C $file ls-remote --get-url)
                printf "%s\n" $file
                return
        end
    end

    return 1
end
