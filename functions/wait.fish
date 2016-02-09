function wait -d "Run commands and display a spinner"
    set -l log
    set -l time 0.02
    set -l option
    set -l commands
    set -l spinners
    set -l format " @\r"

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set commands $commands ";$2"

            case s spin
                set spinners $spinners $2

            case t time
                set time $2

            case l log
                set log $2

            case f format
                set format $2

            case help
                set option help

            case h
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
                wait -h >& 2
                return 1
        end
    end

    switch "$option"
        case help
            man wait
            return
    end

    if not set -q commands[1]
        return 1
    end

    if not set -q spinners[1]
        set spinners mixer
    end

    switch "$spinners"
        case arc star pipe ball flip mixer caret
            set -l arc "◜◠◝◞◡◟"
            set -l star "+x*"
            set -l pipe "|/--\\"
            set -l ball "▖▘▝▗"
            set -l flip "___-``'´-___"
            set -l mixer "⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
            set -l caret "II||"

            set spinners "$$spinners"

        case bar{1,2,3}
            set -l bar
            set -l bar1 "[" "=" " " "]" "%"
            set -l bar2 "[" "#" " " "]" "%"
            set -l bar3 "." "." " " " " "%"

            set -l open $$spinners[1][1]
            set -l fill $$spinners[1][2]
            set -l void $$spinners[1][3]
            set -l close $$spinners[1][4]
            set -l symbol $$spinners[1][5]

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

    set -l tmp (mktemp -t wait.XXX)

    fish -c "$commands" ^ $tmp &

    if not set -q spinners[2]
        set spinners (printf "%s\n" "$spinners" | grep -o .)
    end

    while true
        if status --is-interactive
            for i in $spinners
                printf "$format" | awk -v i=(printf "%s\n" $i | sed 's/=/\\\=/') '
                {
                    gsub("@", i)
                    printf("%s", $0)
                }
                ' > /dev/stderr

                sleep $time
            end
        end

        if test -z (jobs)
            break
        end
    end

    if test -s $tmp
        if test ! -z "$log"
            nl -n command ln -- $tmp > $log
        end

        command rm -f $tmp
        return 1
    end

    command rm -f $tmp
end
