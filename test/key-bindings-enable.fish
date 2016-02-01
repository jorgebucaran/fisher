set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l fixtures $DIRNAME/fixtures/key-bindings/update

function -S setup
    mkdir -p $path

    set -g fisher_key_bindings $path/fisher_key_bindings.fish

    __fisher_key_bindings_enable \
        norf $path/norf/norf.fish \
        < $fixtures/fish_user_key_bindings_function.fish
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Create fish_user_key_bindings calling to __fisher_key_bindings"
    (functions fish_user_key_bindings | xargs) = (cat $path/norf/norf.fish | xargs)
end

test "$TESTNAME - Add plugin bindingss to \$fisher_key_bindings"
    (cat $fisher_key_bindings | xargs) = "##norf## foo bar baz ##norf##"
end
