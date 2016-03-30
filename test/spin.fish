test "$TESTNAME: Fail if no commands are given"
    1 = (
        spin
        echo $status
        )
end

test "$TESTNAME - Fail if there is any output to standard error"
    ok = (
        if not spin "echo errored >& 2" --error=/dev/null
            echo ok
        end
        )
end

test "$TESTNAME - Run commands in the background"
    3 = (spin "math 1 + 2")
end

test "$TESTNAME - Display help information"
    (spin -h | xargs) = "Usage: spin <commands> [--style=<style>] [--format=<string>] [--error=<file>] [--help] -s --style=<string> Use <string> to slice the spinner characters -f --format=<format> Use <format> to customize the spinner display --error=<file> Write errors to <file> -h --help Show usage help"
end
