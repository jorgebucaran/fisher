function __fisher_path_update -a path
    pushd $path

    set -l branch

    if not set branch (sed "s|.*/||" < .git/HEAD)
        return 1
    end

    git checkout master --quiet ^ /dev/null

    git stash --quiet ^ /dev/null

    if not git pull --rebase origin master --quiet ^ /dev/null
        git rebase --abort --quiet
        git fetch origin master --quiet
        git reset --hard FETCH_HEAD --quiet
        git clean -d --force --quiet
    end

    git stash apply --quiet ^ /dev/null

    if test ! -z "$branch"
        git checkout "$branch" --quiet
    end

    popd
end
