set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/foo/functions/nest

    touch $path/foo/foo.fish
    touch $path/foo/functions/{bar,baz,nest/norf}.fish

    # foo
    # |--foo.fish
    # |--functions
    #     |--bar.fish
    #     |--baz.fish
    #     |--nest
    #         |--norf.fish
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Evaluate every fish file inside functions/*"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $1 }') = --source
end

test "$TESTNAME - Move ( <plugin>/{,functions/}*.fish ) TO ( functions/* )"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $3 }' | sed 's|[^/]*$||') = "functions/"
end

test "$TESTNAME - Get function names"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $4 }') = foo bar baz norf
end
