source $DIRNAME/helpers/fisher_mock_repos.fish
source $DIRNAME/helpers/fisher_mock_index.fish
source $DIRNAME/helpers/fisher_mock_config.fish

set -l path $DIRNAME/$TESTNAME.test(random)
set -l source $DIRNAME/fixtures/source
set -l index $path/INDEX
set -l names foo bar baz

function -S setup
    mkdir -p $path

    fisher_mock_repos $source/*
    fisher_mock_index $source $names > $index
    fisher_mock_config $path $index

    fisher install $names -q
    fisher uninstall $names -q
end

function -S teardown
    rm -rf $path
    rm -rf $source/{$names}.git
end

for name in $names
    test "remove plugin from functions/$name.fish"
        ! -e $fisher_config/functions/$name.fish
    end

    test "remove plugin from completions/$name.fish"
        ! -e $fisher_config/completions/$name.fish
    end

    test "remove plugin from conf.d/$name.config.fish"
        ! -e $fisher_config/conf.d/$name.config.fish
    end

    test "remove plugin from conf.d/$name.init.config.fish"
        ! -e $fisher_config/conf.d/$name.init.config.fish
    end
end

test "remove plugin manual from man/man%"
    (for file in $fisher_config/man/**
        basename $file
    end | xargs) = (echo {man}(seq 9) | xargs)
end
