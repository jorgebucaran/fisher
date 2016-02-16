function __fisher_path_update -a path
    pushd $path

    git checkout master --quiet ^ /dev/null
    git pull --rebase origin master --quiet 

    popd
end
