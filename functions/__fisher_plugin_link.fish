function __fisher_plugin_link -a options source target

    # Why not simply run `ln args` inside __fisher_plugin_enable?
    # We want to provide a hook for future plugins to override core functionality.

    ln $options $source $target
end
