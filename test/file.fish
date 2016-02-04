set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l manifest $DIRNAME/fixtures/manifest

# __fisher_file parses a fishfile/bundle and writes declared plugins to standard out.
# URLs and paths are returned *as is*. To retrieve the plugin names use fisher --list

test "$TESTNAME - Parse a fishfile/bundle #1"
    (__fisher_file < $manifest/fishfile) = (cat $manifest/fishfile-parsed)
end

test "$TESTNAME - Parse a fishfile/bundle #2"
    (__fisher_file < $manifest/fishfile-parsed) = (cat $manifest/fishfile-parsed)
end

test "$TESTNAME - Remove `*` and `>` decorators from the input"

    # These characters indicate a plugin is enabled or a plugin is the
    # currently selected prompt.

    (printf "%s\n" "*plugin" ">theme" | __fisher_file) = plugin theme
end
