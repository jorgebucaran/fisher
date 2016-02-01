test "$TESTNAME - Remove plugin- prefix"
    bar = (echo https://github.com/foo/plugin-bar | __fisher_name)
end

test "$TESTNAME - Remove omf-theme- prefix"
    bar = (echo https://github.com/foo/omf-theme-bar | __fisher_name)
end

test "$TESTNAME - Remove theme- prefix"
    bar = (echo https://github.com/foo/theme-bar | __fisher_name)
end

test "$TESTNAME - Remove pkg- prefix"
    bar = (echo https://github.com/foo/pkg-bar | __fisher_name)
end

test "$TESTNAME - Remove omf- prefix"
    bar = (echo https://github.com/foo/omf-bar | __fisher_name)
end

test "$TESTNAME - Remove fish- prefix"
    bar = (echo https://github.com/foo/fish-bar | __fisher_name)
end

test "$TESTNAME - Remove fisher- prefix"
    bar = (echo https://github.com/foo/fisher-bar | __fisher_name)
end

test "$TESTNAME - Pass through other names"
    bar = (echo https://github.com/foo/bar | __fisher_name)
end
