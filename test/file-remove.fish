set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l manifest $DIRNAME/fixtures/manifest

function -S setup
    mkdir -p $path
    cp $manifest/fishfile $path
end

function -S teardown
    rm -rf $path
end

while read -l plugin
    test "$TESTNAME - Remove plugin <$plugin> from fishfile"
        (__fisher_file_remove "$plugin" $path/fishfile) = "$plugin"
    end
end < $manifest/fishfile-no-comments
