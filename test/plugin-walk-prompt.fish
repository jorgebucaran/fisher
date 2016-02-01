set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/{foo,bar,baz}
    touch $path/foo/{fish_{,right_}prompt}.fish

    touch $path/bar/fish_prompt.fish
    touch $path/baz/fish_right_prompt.fish
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Evaluate fish_prompt.fish AND fish_right_prompt.fish files "
    (__fisher_plugin_walk foo $path/foo | awk '{ print $1 }') = --source
end

test "$TESTNAME - Move fish_prompt.fish AND fish_right_prompt.fish TO functions/"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $3 }') = functions/{fish_{,right_}prompt}.fish
end

test "$TESTNAME - Get fish_prompt and fish_right_prompt function names"
    (__fisher_plugin_walk foo $path/foo | awk '{ print $4 }') = fish_{,right_}prompt
end

test "$TESTNAME - Get fish_prompt only if only fish_prompt.fish exists"
    fish_prompt = (__fisher_plugin_walk bar $path/bar | awk '{ print $4 }')
end

test "$TESTNAME - Get fish_right_prompt only if only fish_right_prompt.fish exists"
    fish_right_prompt = (__fisher_plugin_walk baz $path/baz | awk '{ print $4 }')
end
