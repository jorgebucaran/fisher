set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path

    function foobar
        echo foobar
    end
end

function -S teardown
    rm -rf $path
    functions -e foobar
end

test "$TESTNAME - Return the path where the plugin was created"
    $path/foobar = (
        pushd $path
        __fisher_function_to_plugin foobar
        popd
        )
end

test "$TESTNAME - Create a file with the contents of the given function"
    (functions foobar | xargs) = (
        pushd $path
        set -l plugin_path (__fisher_function_to_plugin foobar)
        cat $plugin_path/foobar.fish | xargs
        popd
        )
end
