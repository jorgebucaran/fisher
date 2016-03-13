function __fisher_path_update -a path
    pushd $path

    if not git pull --quiet --rebase origin master
        git rebase --abort
        git fetch --quiet origin master
        git reset --quiet --hard FETCH_HEAD
        git clean --quiet -d --force
    end ^ /dev/null

    popd
end
