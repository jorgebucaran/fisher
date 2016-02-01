# Must be global so that our __fisher_xdg mock can see it.

set -g path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    function -S __fisher_xdg
        echo $path
    end

    function fish_user_key_bindings
        echo "not ok"
    end

    mkdir -p $path/fish/functions

    echo "function fish_user_key_bindings; echo ok; end" \
        > $path/fish/functions/fish_user_key_bindings.fish
end

function -S teardown
    rm -rf $path
    functions -e __fisher_xdg fish_user_key_bindings
end

test "$TESTNAME - Evaluate fish_user_key_bindings.fish and call function"
    (__fisher_key_bindings_reset) = "ok"
end
