function __fisher_help_guides
    sed -nE 's/(fisher-)?(.+)\([0-9]\) -- (.+)/\2;\3/p' \
        {$fisher_home,$fisher_config}/man/man{5,7}/fisher*.md | sort -r
end
