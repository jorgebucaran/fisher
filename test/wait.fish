set -l path $DIRNAME/$TESTNAME.test(random)

function -S setup
    if not mkdir -p $path
        return 1
    end

    pushd $path
end

function -S teardown
    popd
    rm -rf $path
end

test "fail if no commands are given" (
    wait
    echo $status) = 1
end

test "do not redirect standard output"
    (wait "echo output") = output
end

test "fail if there is any output to standard error" (
    wait "echo output > &2"
    echo $status) = 1
end

test "log standard error to log if <file> is given" (
    wait "printf '%s\n' a b c d >&2" --log=$path/log
    cat $path/log | xargs) = "1 a 2 b 3 c 4 d"
end

test "display help"
    (wait --help | xargs) = "usage: wait <commands> [--spin=<style>] [--time=<delay>] [--log=<file>] [--format=<format>] [--help] -s --spin=<style> Set spinner style -t --time=<delay> Set spinner transition time delay -l --log=<file> Output standard error to <file> -f --format=<format> Use given <format> to display spinner -h --help Show usage help"
end
