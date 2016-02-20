function __fisher_gist_to_name -a url
    set -l id (printf "%s\n" "$url" | sed 's|.*/||')

    debug "Get Gist information '%s'" $url

    set -l name (
        spin "curl -Ss https://api.github.com/gists/$id" | awk '

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
