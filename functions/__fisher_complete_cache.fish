function __fisher_complete_cache -d "Add auto-complete for cached plugins"
    set -l IFS ";"
    fisher_search --index=$fisher_cache/.index --select=cache --name --info \
    | while read -l name info
        complete -c fisher -n "__fish_seen_subcommand_from $argv" -a "$name" -d "$info"
    end
end
