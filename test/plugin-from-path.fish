set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l plugin norf

function -S setup
    mkdir -p $path/cache/{foo,bar,baz} $path/local/$plugin
    ln -s $path/local/$plugin $path/cache/$plugin
    set -g fisher_cache $path/cache
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Get plugin in cache from a path"

    # We use fisher_plugin_from_path when we know the path of a local plugin,
    # e.g, by querying the fishfile, and wish to find if it exists in the cache
    # in order to update or uninstall it.

    $path/cache/$plugin = (__fisher_plugin_from_path $path/local/$plugin)
end
