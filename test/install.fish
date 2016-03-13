set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/config/cache

    source $DIRNAME/helpers/config-mock.fish $path/config

    fisher install foo bar --quiet --no-color
    fisher install https://github.com/foobar --quiet --no-color
    fisher install $DIRNAME/fixtures/plugins/baz --quiet --no-color
end

function -S teardown
    rm -rf $path
    source $DIRNAME/helpers/config-mock-teardown.fish
end

test "$TESTNAME - Install given plugins by name, url or path plugins"
    (ls $fisher_cache) = foo bar baz foobar
end

test "$TESTNAME - Local paths are installed as symbolic links"
    -L $path/config/cache/baz
end

for file in cache completions conf.d functions man fishfile key_bindings.fish
    test "$TESTNAME - Add plugin $file to \$fisher_config/$file"
        -e $path/config/$file
    end
end

test "$TESTNAME - Append installed plugins to fishfile"
    foo bar foobar baz = (
        cat $path/config/fishfile
        )
end

test "$TESTNAME - Add plugin key bindings to key_bindings.fish"
    "##foobar## ##foobar##" = (cat $path/config/key_bindings.fish | xargs)
end

test "$TESTNAME - cache/.index is a copy of the URL in \$fisher_index"
    (cat $path/config/cache/.index) = (cat $DIRNAME/fixtures/plugins/index)
end
