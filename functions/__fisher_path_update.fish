function __fisher_path_update -a path
    pushd $path

    git fetch --quiet origin master ^ /dev/null

    set -l commits (
        git rev-list --left-right --count "master..FETCH_HEAD" ^ /dev/null | cut -d\t -f2)

    git reset --quiet --hard FETCH_HEAD ^ /dev/null
    git clean -qdfx

    popd

    if test -z "$commits" -o "$commits" -eq 0
        return 1
    end

    printf "%s\n" "$commits"
end
