function wait -d "Run commands and wait with a spin"
    set -l commands
    set -l spinners
    set -l time 0.03
    set -l log
    set -l format "@\r"

    getopts $argv | while read -l 1 2
        switch "$1"
            case -
            case _
                set commands $commands ";$2"

            case s spin spinner{,s} style
                set spinners $spinners $2

            case t time
                set time $2

            case l log
                set log $2

            case f format
                set format $2

            case h help
                printf "usage: wait <commands> [--spin=<style>] [--time=<delay>] [--log=<file>] \n"
                printf "                       [--format=<format>] [--help]\n\n"

                printf "       -s --spin=<style>  Set spinner style\n"
                printf "       -t --time=<delay>  Set spinner transition time delay\n"
                printf "         -l --log=<file>  Output standard error to <file>\n"
                printf "    -f --format=<format>  Use given <format> to display spinner\n"
                printf "               -h --help  Show usage help\n"
                return

            case \*
                printf "wait: '%s' is not a valid option\n" $1 >& 2
                wait --help >& 2
                return 1
        end
    end

    if not set -q commands[1]
        return 1
    end

    switch "$spinners"
        case arc star pipe ball flip mixer caret
            set -l arc "◜◠◝◞◡◟"
            set -l star "+x*"
            set -l pipe "-\\|/"
            set -l ball "▖▘▝▗"
            set -l flip "___-``'´-___"
            set -l mixer "⠄⠆⠇⠋⠙⠸⠰⠠⠰⠸⠙⠋⠇⠆"
            set -l caret "II||"

            set spinners "$$spinners"

        case bar{1,2,3,\?\?\*}
            set -l bar
            set -l bar1 "[" "=" " " "]" "%"
            set -l bar2 "[" "#" " " "]" "%"
            set -l bar3 "." "." " " " " "%"

            switch "$spinners"
                case \*{1,2,3}
                case \*
                    printf "%s\n" $spinners | sed -E 's/^bar.?//;s/./& /g' | read -az bar
                    set spinners bar
            end

            set -l IFS \t
            printf "%s\t" $$spinners | read -l open fill void close symbol

            set spinners

            for i in (seq 5 5 100)
                if test -n "$symbol"
                    set symbol "$i%"
                end

                set -l gap (printf "$void%.0s" (seq (math 100 - $i)))

                if test $i -ge 100
                    set gap ""
                end

                set spinners $spinners "$open"(printf "$fill%.0s" (seq $i))"$gap$close $symbol"
            end
    end

    set -l tmp (mktemp)

    fish -c "$commands" ^ $tmp &

    if not set -q spinners[2]
        set spinners (printf "%s\n" "$spinners" | grep -o .)
    end

    while true
        if status --is-interactive
            for i in $spinners
                printf "$format" | awk -v t=$time -v i=(printf "%s" $i | sed 's/=/\\\=/') '
                {
                    system("tput civis")
                    gsub("@", i)
                    printf("%s", $0)
                    system("sleep "t";tput cnorm")
                }
                ' > /dev/stderr
            end
        end

        if test -z (jobs)
            printf "$format" | tr @ "\0" > /dev/stderr
            break
        end
    end

    if test -s $tmp
        if set -q log[1]
            nl -n ln -- $tmp > $log
        end

        rm -f $tmp
        return 1
    end

    rm -f $tmp
end
