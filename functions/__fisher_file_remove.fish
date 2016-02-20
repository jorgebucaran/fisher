function __fisher_file_remove -a plugin file
    if __fisher_file_contains $plugin < $file
        set pattern (printf "%s\n" $plugin | __fisher_string_escape)

        if test ! -z "$pattern"
            set pattern "/^$pattern\$/d"
        end

        debug "Remove '%s' from fishfile '%s'" "$plugin" "$file"

        sed -E "$pattern" < $file > $file.tmp

        command mv $file.tmp $file
    end
end
