function __fisher_url_from_path -a path
    if test -z "$path"
        return 1
    end

    if test -L "$path"
        readlink $path
    else
        pushd $path

        set -l url (git ls-remote --get-url ^ /dev/null)

        popd

        if test -z "$url"
            return 1
        end

        switch "$url"
            case \*gist.github.com\*
                printf "%s@%s\n" (basename $path) $url

            case \*
                printf "%s\n" "$url"
        end
    end
end
