function __fisher_path_from_url -a url
    for file in $fisher_cache/*
        pushd $file

        switch "$url"
            case (git ls-remote --get-url)
                printf "%s\n" $file
                popd
                return
        end

        popd
    end

    return 1
end
