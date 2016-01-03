function getopts -d "Parse CLI options"
    if not set -q argv[1]
        return 1
    end

    printf "%s\n" $argv | sed -E '
        s/^-([A-Za-z]+)/- \1 /
        s/^--([A-Za-z0-9_-]+)(!?)=?(.*)/-- \1 \3 \2 /' | \
    awk -f $fisher_home/share/getopts.awk
end
