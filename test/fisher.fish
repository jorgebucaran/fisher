set -l mock_command awk

function -S setup
    set -g fisher_alias "$mock_command=A,B"

    function fisher_$mock_command
        if not set -q argv[1]
            echo Usage:...
            return 1
        end
        awk $argv
    end
end

function -S teardown
    functions -e fisher_$mock_command
end

test "$TESTNAME - Evaluate fisher_ (sub) commands"
    (fisher $mock_command) = Usage:...
end

test "$TESTNAME - Commands can read standard input"
    (echo "foo bar baz" | fisher $mock_command '{ print $2 }' | xargs) = "bar"
end

test "$TESTNAME - Display version information"
    (fisher --version | cut -d " " -f3) = (sed 1q $fisher_home/VERSION)
end

test "$TESTNAME - Handle \$fisher_alias aliases"
    (fisher A; fisher B) = (fisher $mock_command; fisher $mock_command)
end

test "$TESTNAME - Display usage help"
    (fisher | sed 1q) = "Usage: fisher <command> [<arguments>] [--help] [--version]"
end

test "$TESTNAME - Display basic information help info about 'help'"
    (fisher | tail -n2 | xargs) = "Use fisher help <command> to access a man page."
end

test "$TESTNAME - Display basic information about available commands"
    (fisher | sed -E 's/ +//' | grep "^$mock_command\$")
end
