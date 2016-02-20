function __fisher_path_update -a path
    pushd $path

    debug "Update repository '%s'" "$path"

    git checkout master --quiet ^ /dev/null
    git pull --rebase origin master --quiet

    popd
end
