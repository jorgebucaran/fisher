set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path $path/void

    printf "%s\n" foo bar  > $path/bundle
    printf "%s\n" baz norf > $path/fishfile

    function fisher_install
        set -l count 0
        while read -l plugin

            # Fisherman CLI text message are usually written to /dev/stderr,
            # so we must write to /dev/stderr too.

            echo $plugin > /dev/stderr
            set count (math $count + 1)
        end

        echo "$count plugin/s" > /dev/stderr
    end
end

function -S teardown
    rm -rf $path
    functions -e fisher_install
end

test "$TESTNAME - List dependencies to be installed"
    (__fisher_deps_install $path > /dev/null ^| sed -E 's/.*>> (.*)/\1/') = "(foo bar baz norf)"
end

test "$TESTNAME - Install dependencies from one or more bundle/fishfile files"
    (__fisher_deps_install $path ^ /dev/null) = 04
end

test "$TESTNAME - Fail to indicate no dependencies were installed"
    (__fisher_deps_install $path/void) = 0
end
