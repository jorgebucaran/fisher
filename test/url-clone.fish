function -S setup
    function git
        printf "%s\n" $argv
    end
end

function -S teardown
    functions -e git
end

for plugin in foo bar
    set -l url https://github.com/$plugin/$plugin
    set -l path config/cache/$plugin

    test "$TESTNAME - Use Git to clone repo in <$url> into <$path>"
        clone $url $path = (__fisher_url_clone $url $path)
    end
end
