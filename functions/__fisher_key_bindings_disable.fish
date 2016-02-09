function __fisher_key_bindings_disable -a plugin user_key_bindings
    fish_indent < $fisher_key_bindings \
        | __fisher_key_bindings_undo $plugin \
        | source

    __fisher_key_bindings_delete $plugin \
        > $fisher_key_bindings.tmp \
        < $fisher_key_bindings

    command mv -f $fisher_key_bindings.tmp $fisher_key_bindings

    if test ! -s $fisher_key_bindings
        sed -i.tmp '/__fisher_key_bindings/d' $user_key_bindings
        command rm -f $user_key_bindings.tmp
    end
end
