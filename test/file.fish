set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l manifest $DIRNAME/fixtures/manifest

# __fisher_file parses a fishfile/bundle and writes declared plugins to standard out.
# URLs and paths are returned *as is*. To retrieve the plugin names use fisher --list

# See also `list-fishfile.fish`.

test "$TESTNAME - Parse a fishfile/bundle #1"
    (__fisher_file < $manifest/fishfile) = (cat $manifest/fishfile-parsed)
end

test "$TESTNAME - Parse a fishfile/bundle #2"
    (__fisher_file < $manifest/fishfile-parsed) = (cat $manifest/fishfile-parsed)
end
