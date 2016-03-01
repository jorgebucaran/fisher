function __fisher_cache_list
    find -L $fisher_cache/* -printf '%f\n' -maxdepth 0 -type d ^ /dev/null
end
