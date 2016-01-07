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

    fisher install $names[1] file://$source/$names[2..3] -q
end

function -S teardown
    rm -rf $path
    rm -rf $source/{$names}.git
end

test "install creates config directory if there is none"
    -d $fisher_config
end

test "install creates cache directory if there is none"
    -d $fisher_cache
end

test "adds installed plugins to fishfile"
    (cat $fisher_config/fishfile | xargs) = "$names"
end

test "downloads plugin repos to cache"
    (fisher --list) = $names
end

test "download INDEX copy to the cache"
    (cat $fisher_cache/.index) = (fisher_mock_index $source $names)
end

test "add completions/<plugin>.fish to completions directory"
    (ls $fisher_config/completions) = {$names}.fish
end

for name in $names
    test "add <plugin>.fish to functions/$name.fish directory"
        -e $fisher_config/functions/$name.fish
    end

    for file in $fisher_cache/$name/functions/*.fish
        test "add functions/*.fish to functions/"(basename $file)
            -e $fisher_config/functions/(basename $file)
        end
    end

    test "add config files to conf.d"
        -e $fisher_config/conf.d/$name.config.fish
    end

    test "add init files to conf.d as <name>.init.config"
        -e $fisher_config/conf.d/$name.init.config.fish
    end

    test "add manual pages to config/man/"
        -d $fisher_config/man
    end
end

test "install returns 1 if package can't be installed"
    (fisher install -q -- "what"; echo $status) = 1
end
