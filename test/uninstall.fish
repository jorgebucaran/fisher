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
    set -g fisher_cache  $fisher_config/cache
    set -g fisher_index "file://$index"

    create_mock_source $source $names > $index

    fisher install $names --quiet
end

function -S teardown
    rm -rf $path
end

for name in $names
    test "uninstall <$name> does not clear cache"
        (printf "%s\n" $names) = (

        fisher uninstall $name --quiet
        ls $fisher_cache)
    end

    test "uninstall --force clears package <$name> from cache"
        (for _name in $names
            if test $_name != $name
                printf "%s\n" $_name
            end
        end) = (

        fisher uninstall $name --quiet --force
        ls $fisher_cache)
    end

    test "uninstall <$name> removes functions/$name.fish"
        (
            echo 0
            echo 1
        ) = (

        builtin test -f $fisher_config/functions/$name.fish
        echo $status

        fisher uninstall $name --quiet

        builtin test -f $fisher_config/functions/$name.fish
        echo $status)
    end

    test "uninstall <$name> removes completions/$name.fish"
        (
            echo 0
            echo 1
        ) = (

        builtin test -f $fisher_config/completions/$name.fish
        echo $status

        fisher uninstall $name --quiet

        builtin test -f $fisher_config/completions/$name.fish
        echo $status)
    end

    test "uninstall <$name> removes man/man.../$name..."
        (
            for n in (seq 9)
                echo 0
            end

            for n in (seq 9)
                echo 1
            end
        ) = (

        for n in (seq 9)
            builtin test -f $fisher_config/man/man$n/$name.$n
            echo $status
        end

        fisher uninstall $name --quiet

        for n in (seq 9)
            builtin test -f $fisher_config/man/man$n/$name.$n
            echo $status
        end)
    end
end

test "remove all installed/enabled plugins"
    -z (

    fisher uninstall --all --quiet
    ls $fisher_config/functions
    ls $fisher_config/completions)
end

test "remove all installed plugins flushing cache"
    -z (

    fisher uninstall --all --force --quiet
    ls $fisher_cache)
end

test "uninstall updates fishfile"
    "$names[2..-1]" = (

    fisher uninstall $names[1] --quiet
    cat $fisher_config/fishfile | xargs)
end
