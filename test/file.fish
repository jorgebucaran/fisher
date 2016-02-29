set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l manifest $DIRNAME/fixtures/manifest

test "$TESTNAME - Parse a fishfile/bundle #1"
    (__fisher_file < $manifest/fishfile) = (cat $manifest/fishfile-parsed)
end

test "$TESTNAME - Parse a fishfile/bundle #2"
    (__fisher_file < $manifest/fishfile-parsed) = (cat $manifest/fishfile-parsed)
end

test "$TESTNAME - Remove `*` and `>` decorators from the input"
    (printf "%s\n" "*plugin" ">theme" | __fisher_file) = plugin theme
end
