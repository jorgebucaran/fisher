complete -xc fisher

complete -c fisher -n "__fish_use_subcommand" -s l -l list -d "List plugins enabled|disabled|cache|<file>"
complete -c fisher -n "__fish_use_subcommand" -s h -l help -d "Display help"
complete -c fisher -n "__fish_use_subcommand" -s v -l version -d "Show version information"

complete -c fisher -a "fisherman" -d "Update Fisherman" -n "__fish_seen_subcommand_from update"

complete -c fisher -a "\t"                              -n "__fish_seen_subcommand_from search"
complete -c fisher -l "name"    -d "Filter by name"     -n "__fish_seen_subcommand_from search"
complete -c fisher -l "url"     -d "Filter by url"      -n "__fish_seen_subcommand_from search"
complete -c fisher -l "info"    -d "Filter by info"     -n "__fish_seen_subcommand_from search"
complete -c fisher -l "author"  -d "Filter by author"   -n "__fish_seen_subcommand_from search"
complete -c fisher -l "tags"    -d "Filter by tag/s"    -n "__fish_seen_subcommand_from search"

set -l IFS ";"

for option in commands guides
    fisher_help --$option=bare | sed -E 's/^ *([^ ]+) *(.*)/\1;\2/' | while read -l command info
        if test $option = commands
            complete -c fisher -n "__fish_use_subcommand" -a $command -d "$info"

            fisher_help --usage=$command | __fisher_complete fisher $command
        end

        complete -c fisher -n "__fish_seen_subcommand_from help" -a $command -d "$info"
    end
end

set -l plugins (
    if test -s $fisher_file
        __fisher_file < $fisher_file | __fisher_name
    end
    )

begin
    awk -F '\n' -v RS='' -v OFS=';' '

        /^ *#/ { next } { print $1, $3 }

    ' $fisher_cache/.index ^ /dev/null

    __fisher_cache_list

end | sort -ut ';' -k1,1 | while read -l name info

    if contains -- $name $plugins
        complete -c fisher -n "__fish_seen_subcommand_from u update uninstall" -a "$name" -d "$info"
    else
        complete -c fisher -n "__fish_seen_subcommand_from i install" -a "$name" -d "$info"
    end

end
