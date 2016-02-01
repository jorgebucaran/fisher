set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/cache/{foo,bar,baz} $path/norf
    ln -s $path/norf $path/cache/norf

    set -g fisher_cache $path/cache
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Follow symbolic links"
    (contains -- norf (__fisher_cache_list); echo $status) -eq 0
end

test "$TESTNAME - List base name of each plugin inside the cache"
    (__fisher_cache_list) = (
        for plugin in $fisher_cache/*
            basename $plugin
        end
        )
end
