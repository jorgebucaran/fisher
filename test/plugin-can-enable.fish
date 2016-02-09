set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l plugins foo bar baz norf
set -l prompts baz norf

function -S setup
    mkdir -p $path/{$plugins}

    touch $path/{$prompts}/fish_prompt.fish

    set -U fisher_prompt $prompts[1]

    for plugin in $plugins
        __fisher_plugin_can_enable $plugin $path/$plugin
        echo $status
    end > $path/output
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Check whether a plugin is the current prompt or not a prompt."
    0 0 0 1 = (cat $path/output)
end
