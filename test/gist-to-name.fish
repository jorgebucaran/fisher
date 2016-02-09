set -g gist $DIRNAME/fixtures/gist

function -S setup
    function -S curl -a flags url
        cat $gist/(basename $url).json
    end
end

function -S teardown
    functions -e curl
end

test "$TESTNAME - Fail if URL is an empty string"
    1 -eq (
        __fisher_gist_to_name ""
        printf $status
        )
end

test "$TESTNAME - Retrieve the name of the first *.fish file in the JSON stream"
    foo = (__fisher_gist_to_name gist.github.com/foo)
end
