test "$TESTNAME - Convert capital letters to lowercase letters"
    foo = (__fisher_plugin_validate FOO)
end

test "$TESTNAME - Alphabetic names are OK"
    foo = (__fisher_plugin_validate foo)
end

test "$TESTNAME - Single letter names are OK"
    z = (__fisher_plugin_validate z)
end

test "$TESTNAME - Alphanumeric names are OK"
    foo3000 = (__fisher_plugin_validate foo3000)
end

test "$TESTNAME - Numeric names are OK"
    42 = (__fisher_plugin_validate 42)
end

test "$TESTNAME - Delimiters -, _ and . are OK"
    foo-bar_baz.norf = (__fisher_plugin_validate foo-bar_baz.norf)
end

for delim in - . _
    test "$TESTNAME - Delimiter $delim can start a name"
        "{$delim}foo" = (__fisher_plugin_validate "{$delim}foo")
    end
end

set -l some_bad_characters  '%' '&' '(' '~' '|' '^' '$' '"' "'"

test "$TESTNAME - Restrict certain characters ($some_bad_characters)" (
    for bad in $some_bad_characters
        for id in foo bar baz
            __fisher_plugin_validate "$bad$id" > /dev/null
            printf $status
        end
    end
    ) -eq 111111111111111111111111111
end
