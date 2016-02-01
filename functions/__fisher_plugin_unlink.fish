function __fisher_plugin_unlink -a name file
    rm -f $file
    functions -e $name
end
