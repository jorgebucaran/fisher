set -l IFS ";"

for option in commands guides
    fisher_help --$option=bare | sed -E 's/^ *([^ ]+) *(.*)/\1;\2/' | while read -l cmd info

        complete -c fisher -n "__fish_seen_subcommand_from help" -a $cmd -d "$info"

        if test $option != guides
            complete -c fisher -n "__fish_use_subcommand" -a $cmd -d "$info"

            fisher_help --usage=$cmd | __fisher_parse_help OFS=';' | while read -l 1 2 3
                complete -c fisher -n "__fish_seen_subcommand_from $cmd" -s "$3" -l "$2" -d "$1"
            end
        end
    end
end

begin

    for plugin in (__fisher_list)
        printf "%s;%s\n" $plugin ""
    end

    awk -F '\n' -v RS='' -v OFS=';' '/^ *#/ { next } { print $1, $3 }' $fisher_cache/.index

end | while read -l name info
    if contains -- $name $fisher_plugins
        complete -c fisher -n "__fish_seen_subcommand_from u update un uninstall" -a "$name" -d "$info"
    else
        complete -c fisher -n "__fish_seen_subcommand_from install i" -a "$name" -d "$info"
    end
end

complete -c fisher -n "__fish_seen_subcommand_from search" -a "\t"
complete -c fisher -n "__fish_use_subcommand" -s l -l list -d "List plugins in the cache"
complete -c fisher -n "__fish_use_subcommand" -s f -l file -d "Read fishfiles"
complete -c fisher -n "__fish_use_subcommand" -s h -l help -d "Display help"
complete -c fisher -n "__fish_use_subcommand" -s v -l version -d "Show version information"

complete -xc fisher -d "Ahoy! Fisherman"
