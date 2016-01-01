complete -c fisher -n "__fish_use_subcommand" -s v -l version -d "Show version information"
complete -c fisher -n "__fish_use_subcommand" -s h -l help -d "Display help"
complete -c fisher -n "__fish_use_subcommand" -s f -l file -d "Read fishfile"

if test -e $fisher_cache/.index
    set -l cache (for file in $fisher_cache/*
        if test -d $file
            basename $file
        end
    end)

    awk -v FS='\n' -v RS='' -v OFS=' ' '/^ *#/ { next } { print $1,$3 }' $fisher_cache/.index \
    | while read -l name info
        switch "$name"
            case $cache
                for cmd in update uninstall
                    complete -c fisher -n "__fish_seen_subcommand_from $cmd" -a "$name" -d "$info"
                end

            case \*
                complete -c fisher -n "__fish_seen_subcommand_from install" -a "$name" -d "$info"
        end
    end
end

for option in commands guides
    set -l IFS ";"

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

complete -c fisher -n "__fish_seen_subcommand_from search" -a "\t"
complete -xc fisher -d "Fisherman"
