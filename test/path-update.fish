set -g path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Update Git repo at path"
    -z ""
end
