function __fisher_cache_list
    find -L $fisher_cache/* -maxdepth 0 -type d ^ /dev/null | sed 's|.*/||' 
end
