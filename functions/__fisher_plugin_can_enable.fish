function __fisher_plugin_can_enable -a name path
    if not __fisher_path_is_prompt $path
        return 0
    end

    test "$name" = "$fisher_prompt"
end
