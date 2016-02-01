test "$TESTNAME: Fail if no commands are given"
    1 = (
        wait
        echo $status
        )
end

test "$TESTNAME - Fail if there is any output to standard error" (
    if not wait 'echo error >&2'
        echo ok
    end
    ) = ok
end

test "$TESTNAME - Run commands in the background"
    (wait "math 1 + 2") = 3
end

test "$TESTNAME - Display help information"
    (wait -h | xargs) = "usage: wait <commands> [--spin=<style>] [--time=<delay>] [--log=<file>] [--format=<format>] [--help] -s --spin=<style> Set spinner style -t --time=<delay> Set spinner transition time delay -l --log=<file> Output standard error to <file> -f --format=<format> Use given <format> to display spinner -h --help Show usage help"
end
