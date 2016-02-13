set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l fixtures $DIRNAME/fixtures/key-bindings

function -S setup
    mkdir -p $path
    cp $DIRNAME/fixtures/key-bindings/*.fish $path

    set -g fisher_binds $path/fisher_key_bindings.fish

    for plugin in foo bar baz
        __fisher_key_bindings_disable $plugin $path/user_key_bindings.fish >> $path/key_bindings_log
    end
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Remove bindings from fisher key bindings file"
    ! -s $path/fisher_key_bindings.fish
end

test "$TESTNAME - Update fish_user_key_bindings after all bindings are deleted"
    (cat $fixtures/expected/key_bindings) = (cat $path/user_key_bindings.fish)
end

test "$TESTNAME - Undo plugin bindings"
    (cat $fixtures/expected/key_bindings_log) = (cat $path/key_bindings_log)
end
