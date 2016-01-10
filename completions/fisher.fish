complete -xc fisher -d "Ahoy! Fisherman"

complete -c fisher -n "__fish_seen_subcommand_from search" -a "\t"
complete -c fisher -n "__fish_use_subcommand" -s l -l list -d "List plugins in the cache"
complete -c fisher -n "__fish_use_subcommand" -s f -l file -d "Read a fishfile"
complete -c fisher -n "__fish_use_subcommand" -s h -l help -d "Display help"
complete -c fisher -n "__fish_use_subcommand" -s a -l alias -d "Define command aliases"
complete -c fisher -n "__fish_use_subcommand" -s v -l version -d "Show version information"

set -l IFS ";"
for option in commands guides
    fisher_help --$option=bare | sed -E 's/^ *([^ ]+) *(.*)/\1;\2/' | while read -l cmd info

        complete -c fisher -n "__fish_seen_subcommand_from help" -a $cmd -d "$info"

        if test $option = guides
            continue
        end

        complete -c fisher -n "__fish_use_subcommand" -a $cmd -d "$info"

        fisher_help --usage=$cmd | __fisher_complete OFS=';' | while read -l 1 2 3
            complete -c fisher -n "__fish_seen_subcommand_from $cmd" -s "$3" -l "$2" -d "$1"
        end
    end
end

__fisher_complete_cache update uninstall
__fisher_complete_remote install
