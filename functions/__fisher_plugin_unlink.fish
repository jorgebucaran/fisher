function __fisher_plugin_unlink -a name file
    debug "Unlink '%s'" $file
    command rm -f $file
    
    debug "Erase function '%s'" $name
    functions -e $name
end
