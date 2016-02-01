set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/foo
    touch $path/foo/uninstall.fish
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Uninstall uninstall.fish files"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $1 }') = --uninstall
end

# The current approach consists of not moving uninstall.fish to $fisher_config/funtions and
# source it directly from its location $fisher_cache/<plugin> when <plugin> is uninstalled.

test "$TESTNAME - Return path to uninstall.fish in source directory"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $2 }') = $path/foo/uninstall.fish
end
