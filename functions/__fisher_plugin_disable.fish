function __fisher_plugin_disable -a plugin path option
    __fisher_plugin_walk "$plugin" "$path" | while read -l class source target name
        switch "$class"
            case --bind
                debug "Unbind %s" $plugin

                __fisher_key_bindings_disable $plugin (__fisher_xdg --config
                    )/fish/functions/fish_user_key_bindings.fish

            case --uninstall
                __fisher_plugin_uninstall_handler $plugin $source "$option"

            case \*
                __fisher_plugin_unlink $fisher_config/$target $name
        end
    end

    if __fisher_path_is_prompt $path
        __fisher_prompt_reset
    end

    if test -s $fisher_file
        debug "File remove %s" "$plugin"

        __fisher_file_remove (
            if not fisher_search --name=$plugin --name --index=$fisher_cache/.index
                __fisher_url_from_path $path
            end
            ) $fisher_file > /dev/null
    end
end
