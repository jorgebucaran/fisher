set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l option "--foobar"

function -S setup
    mkdir -p $path

    echo "echo source \$argv" > $path/uninstall.fish

    function emit
        echo "emit $argv"
    end
end

function -S teardown
    rm -rf $path
    functions -e emit
end

test "$TESTNAME - Evaluate uninstaller with path and \$option as arguments"
    "source $path $option" = (
        __fisher_plugin_uninstall_handler foo $path/uninstall.fish $option | sed -n 1p
        )
end

test "$TESTNAME - Emit uninstall_<plugin> events with path and \$option as argument"
    "emit uninstall_foo $path $option" = (
        __fisher_plugin_uninstall_handler foo $path/uninstall.fish $option | sed -n 2p
        )
end
