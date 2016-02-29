set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path

    set -g fisher_cache $path
    set -g fisher_index file://$DIRNAME/fixtures/plugins/index

    __fisher_index_update

    function spin -a commands
        eval "$commands"
    end
end

function -S teardown
    rm -rf $path
    functions -e spin
end

test "$TESTNAME - Get only names from index"
    foo bar baz foobar = (fisher search --name)
end

test "$TESTNAME - Get only URLs from index"
    "https://github.com/foo" \
    "https://github.com/bar" \
    "https://github.com/baz" \
    "https://github.com/foobar" = (fisher search --url)
end

test "$TESTNAME - Get only info from index"
    "about foo" "about bar" "about baz" "about foobar" = (fisher search --info)
end

test "$TESTNAME - Get only tags from index"
    foo bar baz = (fisher search --tag)
end

test "$TESTNAME - Get only authors from index"
    foosmith barsmith bazsmith foobarson = (fisher search --author)
end

test "$TESTNAME - Match name and get name"
    "foo" = (fisher search --name=foo --name)
end

test "$TESTNAME - Match name and get URL"
    "https://github.com/foo" = (fisher search --name=foo --url)
end

test "$TESTNAME - Match name and get info"
    "about foo" = (fisher search --name=foo --info)
end

test "$TESTNAME - Match name and get tag/s"
    "foo" "bar" = (fisher search --name=foobar --tag)
end

test "$TESTNAME - Match name and get author"
    "foosmith" = (fisher search --name=foo --author)
end

test "$TESTNAME - Match tag and get author #1"
    "foosmith" "foobarson" = (fisher search --tag=foo --author)
end

test "$TESTNAME - Match tag and get author #2"
    "barsmith" "foobarson" = (fisher search --tag=bar --author)
end

test "$TESTNAME - Match name regex and get author"
    "barsmith" "bazsmith" = (fisher search --name~/^b/ --author)
end

test "$TESTNAME - Match author regex and get url"
    "https://github.com/foo" \
    "https://github.com/bar" \
    "https://github.com/baz" \
    "https://github.com/foobar" = (fisher search --author~/^[fb]/ --url)
end

test "$TESTNAME - Match multiple tags with OR join (default) and get name"
    foobar foo bar = (fisher search --tag={foo,bar} --name)
end

test "$TESTNAME - Match multiple tags with AND join and get name"
    foobar = (fisher search --and --tag={foo,bar} --name)
end

test "$TESTNAME - Match field and get multiple fields #1"
    "bar;https://github.com/bar" "baz;https://github.com/baz" = (
        fisher search --name~/^b/ --name --url)
end

test "$TESTNAME - Match field and get multiple fields #2"
    "foosmith;foo" "foobarson;bar" = (fisher search --name~/^f/ --author --tags)
end
