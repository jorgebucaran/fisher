set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/{foo,bar,baz,norf,quux/modules}

    touch \
        $path/foo/init.fish \
        $path/bar/config.fish \
        $path/baz/baz.config.fish \
        $path/norf/norf.load \
        $path/quux/modules/hoge.fish
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Evaluate init.fish files"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $1 }') = --source
end

test "$TESTNAME - Move ( init.fish ) TO ( conf.d/<plugin>.init.fish )"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $3 }') = conf.d/foo.init.fish
end

test "$TESTNAME - Move ( config.fish ) TO ( conf.d/<plugin>.config.fish )"
    (__fisher_plugin_walk bar $path/bar | awk '{ print $3 }') = conf.d/bar.config.fish
end

test "$TESTNAME - Move ( <plugin>.config.fish ) TO ( conf.d/<plugin>.config.fish )"
    (__fisher_plugin_walk baz $path/baz | awk '{ print $3 }') = conf.d/baz.config.fish
end

test "$TESTNAME - Move ( modules/<file>.fish ) TO ( conf.d/<plugin>.<file>.fish )"
    (__fisher_plugin_walk quux $path/quux | awk '{ print $3 }') = conf.d/quux.hoge.fish
end
