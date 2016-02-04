set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir $path
    echo "echo ok" > $path/foo.fish
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Evaluate file in given path"
    "ok" = (__fisher_plugin_source foo $path/foo.fish)
end
