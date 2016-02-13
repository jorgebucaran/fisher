set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/conf.d

    echo "echo foo" > $path/conf.d/foo.fish

    set -g fisher_config $path

    source $fisher_home/config.fish > /dev/null
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Do not redefine \$fisher_config"
    $fisher_config = $path
end

test "$TESTNAME - Define cache in \$fisher_config/cache (default)"
    $fisher_cache = $path/cache
end

test "$TESTNAME - Define fishfile in \$fisher_config/fishfile (default)"
    $fisher_file = $path/fishfile
end

test "$TESTNAME - Define key bindings in \$fisher_config/key_bindings.fish (default)"
    $fisher_binds = $path/key_bindings.fish
end

test "$TESTNAME - Add Fisherman config/functions to the head of \$fish_function_path"
    $path/functions = $fish_function_path[1]
end

test "$TESTNAME - Add Fisherman config/completions to the head of \$fish_complete_path"
    $path/completions = $fish_complete_path
end

test "$TESTNAME - Evaluate any <*.fish> files inside conf.d during shell start"
    foo = (source $fisher_home/config.fish)
end
