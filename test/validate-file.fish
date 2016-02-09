set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path
    touch $path/file
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Get a valid path"
    "$path" = (__fisher_plugin_validate $path)
end

test "$TESTNAME - Get absolute path if not given a full path"
    "$path" = (
        pushd $path
        __fisher_plugin_validate .
        popd
        )
end

test "$TESTNAME - Remove trailing slashes"
    "$path" = (__fisher_plugin_validate $path/)
end

test "$TESTNAME - Clean up unusual paths"
    "$path" = (
        pushd $path/../../
        __fisher_plugin_validate ./test/.//////(basename $path)
        popd
        )
end

test "$TESTNAME - Fail phoney paths"
    -z (__fisher_plugin_validate /(random)/(random))
end

for invalid_path in ".." "../"
    test "$TESTNAME - Do not allow to install '$invalid_path' like paths"
        -z (__fisher_plugin_validate $invalid_path)
    end
end
