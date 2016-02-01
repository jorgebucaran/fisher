function __fisher_key_bindings_reset
    if functions -q fish_user_key_bindings
        source (__fisher_xdg --config)/fish/functions/fish_user_key_bindings.fish ^ /dev/null
        fish_user_key_bindings
    end
end
