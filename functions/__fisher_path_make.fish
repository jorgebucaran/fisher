function __fisher_path_make -a path
    if test -s $path/Makefile -o -s $path/makefile
        pushd $path

        set -e argv[1]

        if not make $argv
            popd
            return 1
        end

        popd
    end
end
