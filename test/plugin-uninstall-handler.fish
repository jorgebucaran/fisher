set -l path $DIRNAME/.t-$TESTNAME-(random)

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

test "$TESTNAME - Evaluate uninstaller with plugin name and path as arguments"
    (__fisher_plugin_uninstall_handler foo $path/uninstall.fish | sed -n 1p) = "source foo $path/uninstall.fish"
end

test "$TESTNAME - Emit uninstall_<plugin> events with path as argument"
    (__fisher_plugin_uninstall_handler foo $path/uninstall.fish | sed -n 2p) = "emit uninstall_foo $path/uninstall.fish"
end
