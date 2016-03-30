function __fisher_plugin_disable -a plugin path option
    __fisher_plugin_walk "$plugin" "$path" | while read -l class source target name
        switch "$class"
            case --bind
                debug "unbind %s" $plugin

                __fisher_key_bindings_disable $plugin (__fisher_xdg --config
                    )/fish/functions/fish_user_key_bindings.fish

            case --uninstall
                __fisher_plugin_uninstall_handler $plugin $source "$option"

            case \*
                __fisher_plugin_unlink $fisher_config/$target $name

                if test "$name" = set_color_custom
                    __fisher_config_color_reset "$fisher_config/fish_colors"
                end
        end
    end

    if __fisher_path_is_prompt $path
        __fisher_prompt_reset
    end

    if test -s $fisher_file
        set -l key

        if not set key (fisher_search --name=$plugin --name --index=$fisher_cache/.index)
            set key (__fisher_url_from_path $path)
        end

        debug "fishfile remove %s start" "$key"

        if set key (__fisher_file_remove "$key" "$fisher_file")
            debug "fishfile remove %s ok" "$key"
        else
            debug "fishfile remove %s fail" "$key"
        end
    end
end
