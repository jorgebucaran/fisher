set -l IFS ";"

complete -xc fisher

complete -c fisher -n "__fish_use_subcommand" -s h -l help -d "Show usage help"
complete -c fisher -n "__fish_use_subcommand" -s v -l version -d "Show version information"

complete -c fisher -a "fisherman" -d "Update Fisherman" -n "__fish_seen_subcommand_from update"

__fisher_help_guides | while read -l guide info
    complete -c fisher -n "__fish_seen_subcommand_from help" -a $guide -d "$info"
end

__fisher_help_commands | while read -l command info
    complete -c fisher -n "__fish_use_subcommand" -a $command -d "$info"
    complete -c fisher -n "__fish_seen_subcommand_from help" -a $command -d "$info"
    eval fisher_$command -h | __fisher_complete fisher $command
end

set -l plugins (
    if test -s $fisher_file
        __fisher_file < $fisher_file | __fisher_name
    end
    )

begin
    awk -F '\n' -v RS='' -v OFS=';' ' { print $1, $3 } ' $fisher_cache/.index ^ /dev/null
    __fisher_cache_list

end | sort -ut ';' -k1,1 | while read -l name info

    if contains -- $name $plugins
        complete -c fisher -n "__fish_seen_subcommand_from u update uninstall" -a "$name" -d "$info"
    else
        complete -c fisher -n "__fish_seen_subcommand_from i install" -a "$name" -d "$info"
    end
end
