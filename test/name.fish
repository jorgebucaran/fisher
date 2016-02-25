test "$TESTNAME - Remove plugin-* prefix"
    bar = (echo https://github.com/foo/plugin-bar | __fisher_name)
end
test "$TESTNAME - Remove plugin-theme-* prefix"
    bar = (echo https://github.com/foo/plugin-theme-bar | __fisher_name)
end

test "$TESTNAME - Remove omf-theme-* prefix"
    bar = (echo https://github.com/foo/omf-theme-bar | __fisher_name)
end

test "$TESTNAME - Remove theme-omf-* prefix"
    bar = (echo https://github.com/foo/theme-omf-bar | __fisher_name)
end

test "$TESTNAME - Remove theme-* prefix"
    bar = (echo https://github.com/foo/theme-bar | __fisher_name)
end

test "$TESTNAME - Remove pkg-* prefix"
    bar = (echo https://github.com/foo/pkg-bar | __fisher_name)
end

test "$TESTNAME - Remove pkg-pkg-* prefix"
    bar = (echo https://github.com/foo/pkg-pkg-bar | __fisher_name)
end

test "$TESTNAME - Remove omf-* prefix"
    bar = (echo https://github.com/foo/omf-bar | __fisher_name)
end

test "$TESTNAME - Remove fish-* prefix"
    bar = (echo https://github.com/foo/fish-bar | __fisher_name)
end

test "$TESTNAME - Remove fish-fish-* prefix"
    bar = (echo https://github.com/foo/fish-fish-bar | __fisher_name)
end

test "$TESTNAME - Remove fisher-* prefix"
    bar = (echo https://github.com/foo/fisher-bar | __fisher_name)
end

test "$TESTNAME - Remove fisher-fisher-* prefix"
    bar = (echo https://github.com/foo/fisher-fisher-bar | __fisher_name)
end

test "$TESTNAME - Remove fisher-theme-* prefix"
    bar = (echo https://github.com/foo/fisher-theme-bar | __fisher_name)
end

test "$TESTNAME - Remove theme-fisher-* prefix"
    bar = (echo https://github.com/foo/theme-fisher-bar | __fisher_name)
end

test "$TESTNAME - Remove fish-theme-* prefix"
    bar = (echo https://github.com/foo/fish-theme-bar | __fisher_name)
end

test "$TESTNAME - Remove theme-fish-* prefix"
    bar = (echo https://github.com/foo/theme-fish-bar | __fisher_name)
end

test "$TESTNAME - Remove fish-pkg-* prefix"
    bar = (echo https://github.com/foo/fish-pkg-bar | __fisher_name)
end

test "$TESTNAME - Remove pkg-fish-* prefix"
    bar = (echo https://github.com/foo/pkg-fish-bar | __fisher_name)
end

test "$TESTNAME - Remove fisherman-* prefix"
    bar = (echo https://github.com/foo/fisherman-bar | __fisher_name)
end

test "$TESTNAME - Remove fisherman-theme-* prefix"
    bar = (echo https://github.com/foo/fisherman-theme-bar | __fisher_name)
end

test "$TESTNAME - Remove fisherman-plugin-* prefix"
    bar = (echo https://github.com/foo/fisherman-plugin-bar | __fisher_name)
end

test "$TESTNAME - Pass through other names"
    bar = (echo https://github.com/foo/bar | __fisher_name)
end
