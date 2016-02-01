function __fisher_deps_install -a path
    printf 0

    if test -s $path/bundle -o -s $path/fishfile
        printf "Installing dependencies >> (%s)\n" (
            for file in $path/{bundle,fishfile}
                __fisher_list $file
            end | paste -sd ' ' -
            ) > /dev/stderr

        cat $path/{bundle,fishfile} | fisher_install ^| sed -En 's/([0-9]+) plugin\/s.*/\1/p'
    end
end
