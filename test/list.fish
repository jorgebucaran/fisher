set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l fisherman_url https://github.com/fisherman/fisherman

function -S setup
    mkdir -p $path/cache/{foo,bar,baz,norf} $path/theme

    ln -s $path/theme $path/cache/theme

    printf "%s\n" foo bar baz theme > $path/fishfile

    set -g fisher_cache $path/cache

    # Fisherman uses the Fishfile to keep track of what plugins are currently installed
    # so we need to create one in order to test all of fisher --list=<styles>.

    # See also `list-fishfile.fish`.

    set -g fisher_file $path/fishfile
    set -U fisher_prompt theme

    source $DIRNAME/helpers/git-ls-remote.fish
end

function -S teardown
    rm -rf $path
    functions -e git
end

test "$TESTNAME - Wrap fisher -l with __fisher_list"
    (__fisher_list) = (fisher -l)
end

test "$TESTNAME - Wrap fisher --list=cache with fisher --list"
    (fisher --list) = (fisher --list=cache)
end

test "$TESTNAME - Wrap fisher --list with --list=all "
    (fisher --list) = (fisher --list=all)
end

test "$TESTNAME - Append > to active theme"
    (fisher --list | sed -n '/>.*/p') = ">theme"
end

test "$TESTNAME - Append * to active plugins"
    (fisher --list | sed -n '/\*.*/p' | xargs) = "*bar *baz *foo"
end

test "$TESTNAME - Add one space indentation to disabled plugins to align with > and *"
    (fisher --list | sed '/^[\*>].*/d') = " norf"
end

test "$TESTNAME - Do not add indentation when no plugins are enabled"
    (rm $path/fishfile; fisher --list) = (
        for plugin in foo bar baz norf theme
            echo $plugin
        end
        )
end

test "$TESTNAME - Wrap fisher --list=bare with __fisher_cache_list"
    (fisher --list=bare) = (__fisher_cache_list)
end

test "$TESTNAME - Get URL from path (__fisher_url_from_path) with fisher --list=url"
    (fisher --list=url) = (
        for plugin in foo bar baz theme
            switch "$plugin"
                case theme
                    echo $path/theme
                case \*
                    echo https://github.com/$plugin/$plugin
            end
        end
        )
end

test "$TESTNAME - Show active / enabled plugins/prompts with fisher --list=enabled"
    foo bar baz theme = (fisher --list=enabled)
end

test "$TESTNAME - Show disabled/inactive plugins/prompts with fisher --list=disabled"
    (fisher --list=disabled) = norf
end

test "$TESTNAME - Shadow fisher --list=theme to fisher --list=prompt"
    (fisher --list=theme) = (fisher --list=prompt)
end

test "$TESTNAME - Return the contents of \$fisher_prompt fisher --list=theme|prompt"
    (fisher --list=prompt) = theme
end

test "$TESTNAME - Parse a fishfile and display plugins with fisher --list=<file>"
    foo bar baz theme = (fisher --list=$fisher_file)
end
