set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path

    echo "function foo; end" > $path/foo.fish
    source $path/foo.fish

    __fisher_plugin_unlink $path/foo.fish foo
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Delete / Unlink file"
    ! -e $path/foo.fish
end

test "$TESTNAME - Erase function by name"
    -z (functions foo)
end
