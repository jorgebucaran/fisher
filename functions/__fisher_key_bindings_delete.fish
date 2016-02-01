function __fisher_key_bindings_delete -a plugin
    sed "/##$plugin##/,/##$plugin##/d"
end
