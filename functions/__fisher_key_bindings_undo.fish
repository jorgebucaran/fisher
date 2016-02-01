function __fisher_key_bindings_undo -a plugin
    sed -n "/##$plugin##/,/##$plugin##/{s/bind /bind -e /p;};"
end
