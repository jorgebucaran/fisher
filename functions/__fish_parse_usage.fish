function __fish_parse_usage -d "Parse usage help output"
    switch "$argv[1]"
        case -h --help
            printf "Usage\n"
            printf "    __fish_parse_usage [awk_var=value] [--help]\n\n"

            printf "Example\n"
            printf "    set -l IFS \\\t\n"
            printf "    STDIN | __fish_parse_usage | while read -l d l s\n"
            printf "        complete -c <command> -s $s -l $l -d $d\n"
            printf "    end\n"
            return
    end

    switch "$argv"
        case \*OFS=\*
        case \*
            set argv $argv OFS=\t
    end

    awk (printf "-v\n%s\n" $argv) '
        /^ *--?[A-Za-z0-9-]+[, ]?/ {
            re = "[<=\\\[]"
            for (n = 1; n <= NF; n++) {

                if ($n ~ /^--/ && !long) {
                    long = substr($n, 3)
                    split(long, _, re)
                    long = substr(_[1], 1)

                } else if ($n ~ /^-.,?$/ && !short) {
                    short = substr($n, 2, 1)

                } else if ($n !~ re) {
                    info = (info ? info" " : info)$n
                }
            }

            print info, long, short
            info = short = long = ""
        }
    '
end
