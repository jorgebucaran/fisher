function __fisher_path_make -a path
    if test ! -s $path/Makefile -a ! -s $path/makefile
        return
    end

    debug "make %s" "$path/Makefile"

    pushd $path

    set -e argv[1]

    if not make $argv
        debug "make fail %s" "$argv"
        popd
        return 1
    end

    popd
end
