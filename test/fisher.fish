set -l cmd awk
set -l fishfile $DIRNAME/fixtures/fishfile

function -S setup
    set -g fisher_alias "$cmd=A,B"

    function fisher_$cmd
        if not set -q argv[1]
            echo usage:...
            return 1
        end
        awk $argv
    end
end

function -S teardown
    functions -e fisher_$cmd
end

test "read a fishfile using --file"
    (fisher --file=$fishfile) = foo bar baz github/foo/bar
end

test "evaluate commands"
    (fisher $cmd) = usage:...
end

test "evaluate commands w/ standard input"
    (echo "foo bar baz" | fisher $cmd '{ print $2 }' | xargs) = "bar"
end

test "display version information"
    (fisher --version | cut -d " " -f3) = (sed 1q $fisher_home/VERSION)
end

test "evaluate \$fisher_alias=<command=alias[,...]> as aliases"
    (fisher A; fisher B) = (fisher $cmd; fisher $cmd)
end

test "display usage"
    (fisher | sed 1q) = "usage: fisher <command> [<options>] [--version] [--help]"
end

test "display help information about 'help' at the bottom"
    (fisher | tail -n2 | xargs) = "Use fisher help -g to list guides and other documentation. See fisher help <command or concept> to access a man page."
end

test "display basic help information about available commands"
    (fisher | sed -E 's/ +//' | grep "^$cmd\$")
end
