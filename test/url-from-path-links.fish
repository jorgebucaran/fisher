set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/foo
    ln -s $path/foo $path/bar
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Follow symbolic links"
    (readlink $path/bar) = (__fisher_url_from_path $path/bar)
end
