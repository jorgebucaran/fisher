function -S git
    if contains -- ls-remote $argv
        switch (basename (pwd))
            case foo
                echo https://github.com/foo/foo
            case bar
                echo https://github.com/bar/bar
            case baz
                echo https://github.com/baz/baz
            case norf
                echo https://gist.github.com/norf
        end
    end
end
