function __fisher_plugin_unlink -a file name
    debug "Unlink %s" $file
    command rm -f $file

    if test ! -z "$name"
        debug "Erase %s" $name
        functions -e $name
    end
end
