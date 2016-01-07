source $DIRNAME/helpers/fisher_mock_repos.fish
source $DIRNAME/helpers/fisher_mock_index.fish
source $DIRNAME/helpers/fisher_mock_config.fish

set -l path $DIRNAME/$TESTNAME.test(random)
set -l source $DIRNAME/fixtures/source
set -l source2 $path/source
set -l index $path/INDEX
set -l names foo bar baz
set -l names2 norf

function -S setup
    mkdir -p $path

    fisher_mock_repos $source/*
    fisher_mock_index $source $names > $index
    fisher_mock_config $path $index

    fisher install $names -q

    mkdir -p $source2

    cp -rf $source $path

    for name in $names
        set -l file $source2/$name/$name.fish
        sed "s/echo $name/echo $name v2/" $file > $file.tmp
        mv $file.tmp $file

        fisher_mock_repos $source2/$name

        git -C $fisher_cache/$name remote add origin file://$source2/$name
    end

    fisher_mock_index $source $names $names2 > $index
end

function -S teardown
    rm -rf $path
    rm -rf $source/{$names}/.git
end

for name in $names
    test "update <$name> in cache" (
        fisher update $name -q
        eval $name) = "$name v2"
    end
end

test "update index"
    (fisher update --index; cat $fisher_config/cache/.index) = (cat $index)
end
