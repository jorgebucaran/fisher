test "$TESTNAME - Remove trailing .git"
    https://github.com/a/b = (__fisher_plugin_validate https://github.com/a/b.git)
end

for slash in "/" "//" "///"
    test "$TESTNAME - Remove trailing slash/es $slash"
        https://github.com/a/b = (__fisher_plugin_validate https://github.com/a/b$slash)
    end
end

for s in "" s
    for url in "http$s"{//a/b,/a/b,:a/b,:/a/b}
        test "$TESTNAME - Normalize <$url> to <http$s://*>"
            "http$s://a/b" = (__fisher_plugin_validate $url)
        end
    end
end

for url in a/b gh/a/b gh:a/b github/a/b https://github.com/a/b
    test "$TESTNAME - Fix GitHub URLs <$url>"
        https://github.com/a/b = (__fisher_plugin_validate gh:a/b)
    end
end

for url in bb/a/b bb:a/b github/a/b https://github.com/a/b
    test "$TESTNAME - Fix BitBucket URLs <$url>"
        https://github.com/a/b = (__fisher_plugin_validate gh:a/b)
    end
end

for url in omf/a omf:a
    test "$TESTNAME - Fix Oh My Fish! URLs <$url>"
        "https://github.com/oh-my-fish/a" = (__fisher_plugin_validate $url)
    end
end
