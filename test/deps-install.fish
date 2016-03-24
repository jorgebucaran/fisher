set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path $path/void

    printf "%s\n" foo bar  > $path/bundle
    printf "%s\n" baz norf > $path/fishfile

    function fisher_install
        set -l count 0

        while read -l plugin
            set count (math $count + 1)
        end

        echo "$count plugin/s installed."
    end
end

function -S teardown
    rm -rf $path
    functions -e fisher_install
end

test "$TESTNAME - Install dependencies from one or more bundle/fishfile files"
    (__fisher_deps_install $path ^ /dev/null) = 4
end

test "$TESTNAME - Print 0 to indicate no dependencies were installed"
    (__fisher_deps_install $path/void) = 0
end
