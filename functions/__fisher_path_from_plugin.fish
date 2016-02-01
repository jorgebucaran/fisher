function __fisher_path_from_plugin -a plugin
    switch "$plugin"
        case /\*
            __fisher_plugin_from_path $plugin

        case \*/\*
            __fisher_path_from_url $plugin

        case \*
            if test ! -d "$fisher_cache/$plugin"
                return 1
            end

            printf "%s\n" $fisher_cache/$plugin
    end
end
