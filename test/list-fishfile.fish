set -l manifest $DIRNAME/fixtures/manifest

set -l plugins foo bar baz norf zerg quux hoge foobar fred thud chomp boo loo gisty

test "$TESTNAME - Parse fishfile and retrieve plugin names with fisher list fishfile"

    # We use fisher list <file> to parse <file> and then extract the plugin's name
    # as it will be used by the CLI. See also `test/name.fish`.

    (fisher list $manifest/fishfile) = $plugins
end
