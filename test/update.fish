source $DIRNAME/helpers/create_mock_source.fish

set -l path $DIRNAME/$TESTNAME.test(random)
set -l source $path/source
set -l index $path/index
set -l names foo
set -l extra norf

function -S setup
    if not mkdir -p $path
        return 1
    end

    set -g fisher_config $path/config
    set -g fisher_cache $fisher_config/cache
    set -g fisher_index "file://$index"

    create_mock_source $source $names > $index
    fisher install $names --quiet

    # Updates the source repos duplicating the original content.
    # See helpers/create_mock_source.fish

    create_mock_source $source $names $extra > $index
end

function -S teardown
    rm -rf $path
end

for name in $names
    test "update <$name> package copy in cache"
        (functions $name $name | xargs) = (

        fisher update $name --quiet
        fish_indent < $fisher_cache/$name/$name.fish | xargs)
    end

    test "install <$name> if update is successful"
        (functions $name $name | xargs) = (

        fisher update $name --quiet
        fish_indent < $fisher_config/functions/$name.fish | xargs)
    end
end

test "update packages via <stdin>"
    (functions $names $names | xargs) = (

    printf "%s\n" $names | fisher update --quiet
    cat $fisher_config/functions/{$names}.fish | fish_indent | xargs)
end

test "update cache"
    (functions $names $names | xargs) = (

    fisher update --cache --quiet
    cat $fisher_config/functions/{$names}.fish | fish_indent | xargs)
end

test "update index with --index using contents in \$fisher_index" (
    fisher update --index --quiet
    awk -F'\n' -v RS='' '{ print $1 }' $fisher_cache/.index) = $names $extra
end
