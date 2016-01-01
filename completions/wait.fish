set -l spinners arc star pipe ball flip mixer caret bar1 bar2 bar3
complete -xc wait -n "__fish_seen_subcommand_from --spin" -a "$spinners"

complete -xc wait -d "Run commands and wait with a spin"
complete -xc wait -n "not __fish_seen_subcommand_from --spin" -a "\t"

set -l IFS \t
wait --help | __fish_parse_usage | while read -l 1 2 3
    complete -c wait -s "$3" -l "$2" -d "$1"
end
