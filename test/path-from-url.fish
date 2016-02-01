set -l path $DIRNAME/.t-$TESTNAME-(random)

# What is the difference between path-from-url and url-from-path?
# See __fisher_path_from_url.fish for the answer.

function -S setup
    mkdir -p $path/cache/{foo,bar,baz}
    set -g fisher_cache $path/cache

    set -l path $DIRNAME/.t-$TESTNAME-(random)

    source $DIRNAME/helpers/git-ls-remote.fish
end

function -S teardown
    functions -e git
    rm -rf $path
end

for plugin in foo bar baz
    test "$TESTNAME - Get cache path from url <$plugin> using Git"
        $path/cache/$plugin = (__fisher_path_from_url https://github.com/$plugin/$plugin)
    end
end

test "$TESTNAME - Fail if no url does not match any of the plugins ls-remote"
    (__fisher_path_from_url https://github.com/norf/norf > /dev/null; printf $status) -eq 1
end

test "$TESTNAME - Succeed if a url matches any the plugins ls-remote"
    (__fisher_path_from_url https://github.com/bar/bar > /dev/null; printf $status) -eq 0
end
