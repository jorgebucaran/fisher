function __fisher_plugin_link -a options source target
    debug "link %s" $target
    command ln $options $source $target
end
