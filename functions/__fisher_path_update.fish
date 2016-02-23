function __fisher_path_update -a path
    pushd $path

    git checkout master --quiet
    git stash --quiet
    git pull --rebase origin master --quiet
    git stash apply --quiet

    popd
end
