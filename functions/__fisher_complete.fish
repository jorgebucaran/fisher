function __fisher_complete -a parent child
    if test ! -z "$child"
        set child "__fish_seen_subcommand_from $child"
    end

    set -l IFS ';'
    
    __fisher_help_parse | while read -l d l s
        complete -c $parent -s "$s" -l "$l" -d "$d" -n "$child"
    end

    return 0
end
