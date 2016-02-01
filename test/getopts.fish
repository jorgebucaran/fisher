test "$TESTNAME - only bare"
    "_ beer" = (getopts beer)
end

test "$TESTNAME - bare and bare"
    "_ bar" "_ beer" = (getopts bar beer)
end

test "$TESTNAME - bare first"
    "foo" "_ beer" = (getopts beer --foo)
end

test "$TESTNAME - bare sequence"
    "_ foo" "_ bar" "_ baz" "_ quux" = (getopts foo bar baz quux)
end

test "$TESTNAME - bare does not end opts"
    "a" "b 42" "_ beer" "foo" "bar" = (getopts -ab42 beer --foo --bar)
end

test "$TESTNAME - only single"
    "f" "o" "o 42" = (getopts -foo42)
end

test "$TESTNAME - single and single"
    "a" "b" "c" "x" "y" "z" = (getopts -abc -xyz)
end

test "$TESTNAME - single and bare"
    "a" "b" "c bar" = (getopts -abc bar)
end

test "$TESTNAME - single and value"
    "a bar" = (getopts -a bar)
end

test "$TESTNAME - single w/ value and bare"
    "a" "b" "c ./" "_ bar" = (getopts -abc./ bar)
end

test "$TESTNAME - single and double"
    "a" "b" "c" "foo" = (getopts -abc --foo)
end

test "$TESTNAME - double"
    "foo" = (getopts --foo)
end

test "$TESTNAME - double w/ value"
    "foo bar" = (getopts --foo=bar)
end

test "$TESTNAME - double w/ negated value"
    "foo bar !" = (getopts --foo!=bar)
end

test "$TESTNAME - double w/ value group"
    "foo bar" "bar foo" = (getopts --foo=bar --bar=foo)
end

test "$TESTNAME - double w/ value and bare"
    "foo bar" "_ beer" = (getopts --foo=bar beer)
end

test "$TESTNAME - double double"
    "foo" "bar" = (getopts --foo --bar)
end

test "$TESTNAME - double w/ inner dashes"
    "foo-bar-baz" = (getopts --foo-bar-baz)
end

test "$TESTNAME - double and single"
    "foo" "a" "b" "c" = (getopts --foo -abc)
end

test "$TESTNAME - multiple double sequence"
    "foo" "bar" "secret 42" "_ baz" = (getopts  --foo --bar --secret=42 baz)
end

test "$TESTNAME - single double single w/ remaining bares"
    "f" "o" "o" "bar" "b" "a" "r norf" "_ baz" "_ quux" = (
    getopts -foo --bar -bar norf baz quux)
end

test "$TESTNAME - double dash"
    "_ --foo" "_ bar" = (getopts -- --foo bar)
end

test "$TESTNAME - single double dash"
    "a" "_ --foo" "_ bar" = (getopts -a -- --foo bar)
end

test "$TESTNAME - bare and double dash"
    "foo bar" "_ baz" "_ foo" "_ --foo" = (getopts --foo=bar baz -- foo --foo)
end

test "$TESTNAME - long string as a value"
    "f Fee fi fo fum" = (getopts -f "Fee fi fo fum")
end

test "$TESTNAME - single and empty string"
    "f" = (getopts -f "")
end

test "$TESTNAME - double and empty string"
    "foo" = (getopts --foo "")
end

test "$TESTNAME - ignore repeated options"
    "x" = (getopts -xxx | xargs)
end
