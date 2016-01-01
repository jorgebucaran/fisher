source $DIRNAME/helpers/create_mock_source.fish

set -l path $DIRNAME/$TESTNAME.test(random)
set -l source $path/source
set -l index $path/index
set -l names foo bar

function -S setup
    if not mkdir -p $path
        return 1
    end

    set -g fisher_config $path/config
    set -g fisher_cache $fisher_config/cache
    set -g fisher_index "file://$index"

    create_mock_source $source $names > $index
end

function -S teardown
    rm -rf $path
end

for name in $names
    test "install by name:<$name>" (
        fisher install $name --quiet
        ls $fisher_cache

        ) = $name
    end

    test "install by url:<file://$source/$name>" (
        fisher install file://$source/$name --quiet
        ls $fisher_cache

        ) = $name
    end
end

test "install several"
    (printf "%s\n" $names) = (

    fisher install $names --quiet
    ls $fisher_cache)
end

test "install from <stdin>"
    (printf "%s\n" $names) = (

    printf "%s\n" $names | fisher install --quiet
    ls $fisher_cache)
end

test "install updates fishfile"
    "$names" = (

    fisher install $names --quiet
    xargs < $fisher_config/fishfile)
end

test "fail install package by name"
    "fisher: 'what' not found" = (

    fisher install "what" ^&1
    echo $status)
end
