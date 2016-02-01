set -l IFS \t

complete -xc wait -n "__fish_seen_subcommand_from --spin" \
    -a "spinners arc star pipe ball flip mixer caret bar1 bar2 bar3"
    
complete -xc wait -n "not __fish_seen_subcommand_from --spin" -a "\t"

wait -h | __fisher_complete wait
