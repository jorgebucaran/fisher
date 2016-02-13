function __fisher_key_bindings_disable -a plugin user_key_bindings
    fish_indent < $fisher_binds \
        | __fisher_key_bindings_undo $plugin \
        | source

    __fisher_key_bindings_delete $plugin \
        > $fisher_binds.tmp \
        < $fisher_binds

    command mv -f $fisher_binds.tmp $fisher_binds

    if test ! -s $fisher_binds
        sed -i.tmp '/__fisher_key_bindings/d' $user_key_bindings
        command rm -f $user_key_bindings.tmp
    end
end
