function -S git -a 1 file ctx action
    if test "$ctx" = "ls-remote" -a "$action" = --get-url
        switch (basename "$file")
            case foo
                echo https://github.com/foo/foo
            case bar
                echo https://github.com/bar/bar
            case baz
                echo https://github.com/baz/baz
        end
    end
end
