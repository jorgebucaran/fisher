set -l manifest $DIRNAME/fixtures/manifest

set -l plugins foo bar baz quux hoge foobar fred thud chomp gisty mof

test "$TESTNAME - Parse fishfile and retrieve plugin names with fisher list fishfile"
    $plugins = (
        fisher list - < $manifest/fishfile
        )
end
