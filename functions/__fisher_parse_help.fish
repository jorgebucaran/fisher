function __fisher_parse_help -d "parse usage help output"
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
