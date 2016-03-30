function __fisher_plugin_unlink -a file name
    debug "unlink %s" $file
    command rm -f $file

    if test ! -z "$name"
        debug "erase %s" $name
        functions -e $name
    end
end
