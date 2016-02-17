function __fisher_plugin_uninstall_handler -a plugin file option
    set -l path (dirname $file)

    if source $file $path "$option"
        emit uninstall_$plugin $path "$option"
        functions -e uninstall_$plugin
    end
end
