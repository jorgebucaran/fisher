function __fisher_path_update -a path
    pushd $path

    set -l branch

    if not set branch (sed "s|.*/||" < .git/HEAD)
        return 1
    end

    if test "$branch" != master
        git stash --quiet ^ /dev/null
        git checkout master --quiet ^ /dev/null
    end

    if not git pull --rebase origin master --quiet ^ /dev/null
        git rebase --abort --quiet
        git fetch origin master --quiet
        git reset --hard FETCH_HEAD --quiet
        git clean -d --force --quiet
    end

    if test "$branch" != master
        git checkout "$branch" --quiet
        git stash apply --quiet ^ /dev/null
    end

    popd
end
