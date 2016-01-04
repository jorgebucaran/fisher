complete -xc fisher -d "Fisherman"
complete -c fisher -n "__fish_seen_subcommand_from search" -a "\t"
complete -c fisher -n "__fish_use_subcommand" -s v -l version -d "Show version information"
complete -c fisher -n "__fish_use_subcommand" -s h -l help -d "Display help"
complete -c fisher -n "__fish_use_subcommand" -s f -l file -d "Read fishfile"

set -l index $fisher_cache/.index
set -l IFS ";"

for option in commands guides
    fisher help --$option=bare | sed -E 's/^ *([^ ]+) *(.*)/\1;\2/' | while read -l func info

        complete -c fisher -n "__fish_seen_subcommand_from help" -a $func -d "$info"

        if test $option = guides
            continue
        end

        complete -c fisher -n "__fish_use_subcommand" -a $func -d "$info"

        fisher_help --usage=$func | __fish_parse_usage OFS=';' | while read -l 1 2 3
            complete -c fisher -n "__fish_seen_subcommand_from $func" -s "$3" -l "$2" -d "$1"
        end
    end
end

if test -e $fisher_cache/.index
    fisher search --index=$index --select=cache --name --info | while read -l name info
        for command in update uninstall
            complete -c fisher -n "__fish_seen_subcommand_from $command" -a "$name" -d "$info"
        end
    end

    fisher search --index=$index --select=remote --name --info | while read -l name info
        complete -c fisher -n "__fish_seen_subcommand_from install" -a "$name" -d "$info"
    end
end
