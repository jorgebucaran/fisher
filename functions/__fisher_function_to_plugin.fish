function __fisher_function_to_plugin -a name
    if test -d "$name"
        return 1
    end

    set -l path (pwd)/$name
    mkdir -p "$path"

    functions -- $name | fish_indent > "$path/$name.fish"

    printf "%s\n" "$path"
end
