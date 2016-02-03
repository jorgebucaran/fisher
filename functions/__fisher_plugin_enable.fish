function __fisher_plugin_enable -a plugin path
    if __fisher_path_is_prompt $path
        if test ! -z "$fisher_prompt"

            # Why do we need to disable a prompt before installing another? I thought
            # one prompt would override the other?

            # While this is true for fish_prompt and fish_right_prompt, a prompt is no
            # different from other plugins and may optionally include other functions,
            # shared scripts, completions, documentation, etc.

            __fisher_plugin_disable "$fisher_prompt" "$fisher_cache/$fisher_prompt"
        end

        set -U fisher_prompt $plugin
    end

    set -l link -f

    if test -L $path

        # The path will be a soft link if the user tried to install a plugin from
        # any directory in the local system, including plugins registered in the
        # index. In this case we want to create soft links from <path> (which is
        # also a soft link) as we walk the plugin's directory.

        # The advantage of creating soft links from local projects is that it
        # allows rapid prototyping / debugging of new or existing plugins.

        set link -sfF
    end

    __fisher_plugin_walk "$plugin" "$path" | while read -l class source target __unused
        switch "$class"
            case --bind
                __fisher_key_bindings_enable $plugin (__fisher_xdg --config
                    )/fish/functions/fish_user_key_bindings.fish < $source

            case --uninstall
            case \*
                if test "$class" = --man
                    mkdir -p (dirname $fisher_config/$target)
                end

                __fisher_plugin_link $link $source $fisher_config/$target

                if test "$class" = --source
                    __fisher_plugin_source $fisher_config/$target
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
            return
        end
    end

    printf "%s\n" $item >> $fisher_file
end
