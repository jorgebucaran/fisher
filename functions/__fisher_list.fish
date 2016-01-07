function __fisher_list -d "List plugins in the cache"
    for file in $fisher_cache/*
        if test -d $file
            basename $file
        end
    end
end
