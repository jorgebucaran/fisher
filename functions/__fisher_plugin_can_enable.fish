function __fisher_plugin_can_enable -a name path

    # Check whether a plugin is the current prompt or not a prompt. We use this
    # method when the user is trying to Update or Uninstall a prompt that is not
    # currently enabled, and we wish to skip only the enable / disable phase.

    if not __fisher_path_is_prompt $path
        return 0
    end

    test "$name" = "$fisher_prompt"
end
