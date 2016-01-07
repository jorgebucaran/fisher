function __fisher_complete_remote -d "Add auto-complete for remote plugins"
    set -l IFS ";"
    fisher_search --index=$fisher_cache/.index --select=remote --name --info \
    | while read -l name info
        complete -c fisher -n "__fish_seen_subcommand_from $argv" -a "$name" -d "$info"
    end
end
