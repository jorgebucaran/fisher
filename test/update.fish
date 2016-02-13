set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/config/cache

    source $DIRNAME/helpers/config-mock.fish $path/config

    function __fisher_path_update
        echo "$argv[1]"
    end

    fisher install foo --quiet
    fisher update foo > $path/foo --quiet

    fisher update --quiet > $path/self
end

function -S teardown
    rm -rf $path
    source $DIRNAME/helpers/config-mock-teardown.fish
end

test "$TESTNAME - Update plugin path"
    (cat $path/foo) = "$path/config/cache/foo"
end

test "$TESTNAME - Update Index and \$fisher_home"
    (cat $path/self) = $fisher_home
end
