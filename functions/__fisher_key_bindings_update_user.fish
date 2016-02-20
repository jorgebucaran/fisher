function __fisher_key_bindings_update_user
    awk -v src=__fisher_key_bindings '
        NR == 2 {
            printf("%s\n", src)
        }

        $0 !~ "^[ \t]*" src { print }
        
    ' | fish_indent
end
