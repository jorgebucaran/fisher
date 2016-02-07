set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    set -g fisher_cache $path/cache
    set -g fisher_index file://$path/fake-index

    mkdir -p $fisher_cache

    seq 5 > $path/fake-index

    __fisher_index_update
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Update index via curl method"
    (seq 5) = (cat $fisher_cache/.index)
end

test "$TESTNAME - Remove .tmp swap index file"
    ! -e $fisher_cache/.index.tmp
end
