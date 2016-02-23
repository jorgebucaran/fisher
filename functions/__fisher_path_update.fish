function __fisher_path_update -a path
    pushd $path

    git checkout master --quiet
    git stash --quiet ^ /dev/null
    git pull --rebase origin master --quiet
    git stash apply --quiet ^ /dev/null

    popd
end
