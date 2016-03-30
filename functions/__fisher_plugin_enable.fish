function __fisher_plugin_enable -a plugin path
    debug "enable %s" "$plugin"

    if __fisher_path_is_prompt $path
        if test ! -z "$fisher_prompt"
            debug "disable prompt %s" $fisher_prompt
            __fisher_plugin_disable "$fisher_prompt" "$fisher_cache/$fisher_prompt"
        end

        set -U fisher_prompt $plugin
    end

    set -l link -sfF

    __fisher_plugin_walk "$plugin" "$path" | while read -l class source target name
        switch "$class"
            case --bind
                debug "bind %s" $source

                __fisher_key_bindings_enable $plugin (__fisher_xdg --config
                    )/fish/functions/fish_user_key_bindings.fish < $source

            case --uninstall
            case \*
                if test "$class" = --man
                    command mkdir -p (dirname $fisher_config/$target)
                end

                __fisher_plugin_link $link $source $fisher_config/$target

                if test "$class" = --source
                    debug "source %s" "$fisher_config/$target"
                    __fisher_plugin_source $plugin $fisher_config/$target

                    if test "$name" = set_color_custom
                        debug "color save"
                        __fisher_config_color_save "$fisher_config/fish_colors"
                        set_color_custom
                    end
                end
        end
    end

    set -l item (
        if not fisher_search --name=$plugin --name --index=$fisher_cache/.index
            __fisher_url_from_path $path
        end
        )

    if test -s $fisher_file
        if __fisher_file_contains "$item" --quiet $fisher_file
            debug "file skip %s" "$item"
            return
        end
    end

    debug "file add %s" "$item"

    printf "%s\n" $item >> $fisher_file
end
