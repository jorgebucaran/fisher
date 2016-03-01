function __fisher_plugin_source -a plugin file
    debug "Source %s" $file
    source "$file" ^ /dev/null
end
