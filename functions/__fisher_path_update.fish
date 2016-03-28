function __fisher_path_update -a path
    pushd $path

    git fetch --quiet origin master ^ /dev/null

    set -l commits (
        git rev-list --left-right --count "master..FETCH_HEAD" ^ /dev/null | cut -d\t -f2)

    git reset --quiet --hard FETCH_HEAD
    git clean -qdfx

    popd

    if test "$commits" -eq 0 -o -z "$commits"
        return 1
    end

    printf "%s\n" "$commits"
end
