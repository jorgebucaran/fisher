set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/foo/conf.d
    touch $path/foo/conf.d/foo.fish
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Evaluate files inside conf.d"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $1 }') = "--source"
end

test "$TESTNAME - Move files inside conf.d to conf.d"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $3 }') = "conf.d/foo.fish"
end
