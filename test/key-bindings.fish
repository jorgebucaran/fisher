set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path

    set -g fisher_key_bindings $path/key_bindings.fish

    echo echo ok > $fisher_key_bindings
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Evaluate \$fisher_key_bindings"
    (__fisher_key_bindings) = ok
end
