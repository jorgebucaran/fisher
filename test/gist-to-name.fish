set -g gist $DIRNAME/fixtures/gist

function -S setup
    function -S spin -a url
        cat $gist/(basename $url).json ^ /dev/null
    end
end

function -S teardown
    functions -e spin
end

test "$TESTNAME - Fail if URL is an empty string"
    1 -eq (
        __fisher_gist_to_name ""
        printf $status
        )
end

test "$TESTNAME - Fail if URL is invalid"
    -z (__fisher_gist_to_name gist.github.com/bar)
end

test "$TESTNAME - Retrieve the name of the first *.fish file in the JSON stream"
    foo = (__fisher_gist_to_name gist.github.com/foo)
end
