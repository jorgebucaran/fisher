set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/config/cache

    source $DIRNAME/helpers/config-mock.fish $path/config

    fisher install foo bar foobar --quiet --no-color
    fisher uninstall foo --quiet
    fisher uninstall foobar --quiet --force
end

function -S teardown
    rm -rf $path
    source $DIRNAME/helpers/config-mock-teardown.fish
end

for plugin in foo foobar
    test "$TESTNAME - Uninstall a plugin ($plugin)"
        ! -f $path/config/functions/$plugin.fish
    end
end

test "$TESTNAME - Remove plugin from fishfile"
    bar = (cat $fisher_file)
end

test "$TESTNAME - *Do not* remove from cache unless --force is used"
    -d $fisher_cache/foo
end

test "$TESTNAME - Remove plugin from cache using --force is used"
    ! -e $fisher_cache/foobar
end

test "$TESTNAME - Remove plugin key bindings from key_bindings.fish"
    -z (cat $path/config/key_bindings.fish | xargs)
end

test "$TESTNAME - Remove plugin \$fisher_config/completions"
    ! -e $path/config/completions/foobar.fish
end

test "$TESTNAME - Remove plugin startup configuration from \$fisher_config/conf.d"
    ! -e $path/config/conf.d/conf.fish
end
