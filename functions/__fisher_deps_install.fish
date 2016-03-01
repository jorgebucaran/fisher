function __fisher_deps_install -a path
    for file in $path/{fishfile,bundle}
        if test -s $file
            debug "Install deps %s" "$file"
            fisher_install < $file | sed -En 's/^.+([0-9]+) plugin\/s.*/\1/p'
        end
    end | awk '{ n = n + $0 } END { print n ? n : 0 }'
end
