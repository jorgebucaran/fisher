# What is the difference between $fisher_index and $fisher_cache/.index?

# The first one is a URL to a plain text file that lists all registered
# plugins and the second is a copy of that file.

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

test "$TESTNAME - Return 1 if operation (curl) fails"
    1 -eq (
        set -e fisher_index
        __fisher_index_update ^ /dev/null
        echo $status
        )
end

test "$TESTNAME - Original index is not modified in case of failure"
    (seq 5) = (
        set -e fisher_index
        __fisher_index_update ^ /dev/null
        cat $fisher_cache/.index
        )
end
