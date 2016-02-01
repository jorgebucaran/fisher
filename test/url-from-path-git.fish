function -S setup
    source $DIRNAME/helpers/git-ls-remote.fish
end

function -S teardown
    functions -e git
end

for plugin in foo bar baz
    test "$TESTNAME - Get URL from repo's path in the cache ($plugin)"
        "https://github.com/$plugin/$plugin" = (__fisher_url_from_path ...cache/$plugin)
    end
end

test "$TESTNAME - Fail if path is not given"
    (__fisher_url_from_path ""; printf $status) -eq 1
end
