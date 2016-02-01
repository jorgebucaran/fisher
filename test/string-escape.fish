set -l strings "https://github.com/foo/foo" "/Users/foo/bar/baz"
set -l escaped "https:\/\/github.com\/foo\/foo" "\/Users\/foo\/bar\/baz"

test "$TESTNAME - Escape slases in paths and url"
    (printf "%s\n" $strings | __fisher_string_escape) = $escaped
end
