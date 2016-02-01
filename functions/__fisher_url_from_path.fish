function __fisher_url_from_path -a path
    if test -z "$path"
        return 1
    end

    if test -L "$path"
        readlink $path
    else
        git -C "$path" ls-remote --get-url ^ /dev/null
    end
end
