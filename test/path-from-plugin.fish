set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/cache{/foo}
    set -g fisher_cache $path/cache

    function __fisher_plugin_from_path
        echo --plugin-from-path
    end

    function __fisher_path_from_url
        echo --path-from-url
    end
end

function -S teardown
    rm -rf $path
    functions -e __fisher_plugin_from_path __fisher_path_from_url
end

test "$TESTNAME - Use __fisher_plugin_from_path if a path is given"
    (__fisher_path_from_plugin /path/to/foo) = --plugin-from-path
end

test "$TESTNAME - Use __fisher_path_from_url if a url is given"
    (__fisher_path_from_plugin https://github.com/foo/foo) = --path-from-url
end

test "$TESTNAME - Get cache path of plugin if it exists in the cache"
    (__fisher_path_from_plugin foo) = $fisher_cache/foo
end

test "$TESTNAME - Fail if plugin does not exist in the cache"
    (__fisher_path_from_plugin norf; printf $status) -eq 1
end
