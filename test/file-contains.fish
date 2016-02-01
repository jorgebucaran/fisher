set -l manifest $DIRNAME/fixtures/manifest

while read -l plugin
    test "$TESTNAME - Check if plugin <$plugin> exists in fishfile"
        (__fisher_file_contains "$plugin" < $manifest/fishfile) = "$plugin"
    end
end < $manifest/fishfile-no-comments
