function -S setup
    function complete
        echo $argv
    end

    function foo
        echo "-f --foo Foo!"
    end

    function bar
        echo "--bar Bar!"
    end
end

function -S teardown
    functions -e complete foo bar
end

test "$TESTNAME - Complete short / long options with description"
    (foo | __fisher_complete norf quux
        ) = "-c norf -s f -l foo -d Foo! -n __fish_seen_subcommand_from quux"
end

test "$TESTNAME - Complete long options with description"
    (bar | __fisher_complete norf quux
        ) = "-c norf -s  -l bar -d Bar! -n __fish_seen_subcommand_from quux"
end
