source $DIRNAME/helpers/create_mock_source.fish

set -l path $DIRNAME/$TESTNAME.test(random)
set -l server $path/server
set -l home fisherman

function -S setup
    set -g fisher_home $path/home

    if not mkdir -p $fisher_home
    return 1
    end

    create_mock_source $server $home > /dev/null

    git -C $fisher_home init --quiet
    git -C $fisher_home remote add origin $server/$home/.git
end

function -S teardown
    rm -rf $path
end

test "update itself w/ --self"
    (ls $server/$home) = (

    fisher update --self --quiet ^/dev/null
    ls $fisher_home)
end

test "update repo at given path via git pull"
    (ls $server/$home) = (

    fisher update --path=$fisher_home --quiet ^/dev/null
    ls $fisher_home)
end
