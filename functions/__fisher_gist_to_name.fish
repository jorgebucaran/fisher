function -S __fisher_gist_to_name -a url
    set -l gist_id (printf "%s\n" "$url" | sed 's|.*/||')

    set -l name (
        spin "curl -Ss https://api.github.com/gists/$gist_id" -f "  $color@$color_normal\r" | awk '

            /"files": / { files++ }

            /"[^ ]+.fish": / && files {
                gsub("^ *\"|\.fish.*", "")
                print
            }
        '
    )

    if test -z "$name"
        return 1
    end

    printf "%s\n" $name
end
