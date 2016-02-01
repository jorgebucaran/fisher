function __fisher_plugin_uninstall_handler -a plugin file
    if source $file $plugin $file
        emit uninstall_$plugin $file
    end
end
