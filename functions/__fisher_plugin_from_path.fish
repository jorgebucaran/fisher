function __fisher_plugin_from_path -a path
    for plugin in $fisher_cache/*
        switch "$path"
            case (readlink $plugin)
                printf "%s\n" $plugin
                return
        end
    end

    return 1
end
