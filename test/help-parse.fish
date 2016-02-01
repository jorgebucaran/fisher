function -S setup
    function foo
        printf "%s\n" "usage: foo [options] ..."
        printf "%s\n" "options:"
        printf "%s\n" "  --version Show version"
        printf "%s\n" "  -h --help Show help"
    end
end

function -S teardown
    functions -e foo
end

test "$TESTNAME - Parse single long option with description"
    (foo | __fisher_help_parse | sed -n 1p) = "Show version;version;"
end

test "$TESTNAME - Parse short and long option with description "
    (foo | __fisher_help_parse | sed -n 2p) = "Show help;help;h"
end

test "$TESTNAME - Ignore non-option info, e.g, usage:, options:, etc."
    (foo | __fisher_help_parse | xargs) = "Show version;version; Show help;help;h"
end
