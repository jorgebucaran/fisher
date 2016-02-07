function __fisher_plugin_unlink -a name file
    command rm -f $file
    functions -e $name
end
