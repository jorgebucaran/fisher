set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l extensions py rb php pl awk sed

function -S setup
    mkdir -p $path/{foo/scripts,bar}

    touch $path/foo/scripts/foo.{$extensions}
    touch $path/bar/bar.{$extensions}
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Do not source scripts/*.{$extensions} files"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $1 }') = --
end

test "$TESTNAME - Move <plugin>/scripts/*.{$extensions} TO scripts/*"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $3 }') = scripts/foo.{$extensions}
end

test "$TESTNAME - Move <plugin>/*.{$extensions} TO functions/*"
    (__fisher_plugin_walk bar $path/bar | awk '{ print $3 }') = functions/bar.{$extensions}
end
