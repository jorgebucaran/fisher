function __fisher_path_update -a path
    pushd $path

    set -l branch

    if not set branch (sed "s|.*/||" < .git/HEAD)
        return 1
    end

    git stash           --quiet ^ /dev/null
    git checkout master --quiet ^ /dev/null

    if not git pull --quiet --rebase origin master
        git rebase  --quiet --abort
        git fetch   --quiet origin master
        git reset   --quiet --hard FETCH_HEAD
        git clean   --quiet -d --force
    end ^ /dev/null

    if test ! -z "$branch"
        git checkout "$branch" --quiet ^ /dev/null
    end

    git stash apply --quiet ^ /dev/null

    popd
end
