function __fisher_gist_to_name -a url
    if test -z "$url"
        return 1
    end

    set -l id (printf "%s\n" $url | sed 's|.*/||')
    set -l gists https://api.github.com/gists

    set -l name (
        curl -s $gists/$id | awk '

        /"files": / { files++ }

        /"[^ ]+.fish": / && files {
            gsub("^ *\"|\.fish.*", "")
            print
        }

    ' ^ /dev/null
    )

    if test -z "$name"
        return 1
    end

    printf "%s\n" $name
end
