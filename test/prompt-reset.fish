# Must be global so that our __fisher_xdg mock can see it.
set -g path $DIRNAME/.t-$TESTNAME-(random)

# Fishtape does not restore "private" variables by design.
set -g __fish_datadir_save $__fish_datadir

function -S setup
    mkdir -p $path/{foo,fish,default}/functions

    function -S __fisher_xdg
        echo $path
    end

    echo "echo foo" > $path/foo/functions/fish_prompt.fish
    echo "echo bar" > $path/fish/functions/fish_prompt.fish
    echo "echo baz" > $path/default/functions/fish_prompt.fish

    set __fish_datadir $path/default

    set -U fisher_prompt theme
end

function -S teardown
    set __fish_datadir $__fish_datadir_save

    functions -e __fisher_xdg
    rm -rf $path
end

test "$TESTNAME - Evaluate fish_prompt in user config by default if there is onee"
    bar = (__fisher_prompt_reset)
end

test "$TESTNAME - Evaluate prompt at given path/s if given"
    foo = (__fisher_prompt_reset $path/foo)
end

test "$TESTNAME - Evaluate fish_prompt in __fish_datadir otherwise"
    baz = (
        rm -rf $path/fish
        __fisher_prompt_reset)
end


test "$TESTNAME - Reset fisher_prompt"
    "theme;" = (
        printf "$fisher_prompt"
        __fisher_prompt_reset > /dev/null
        printf ";$fisher_prompt")
end




















# set -l path $DIRNAME/.t-$TESTNAME-(random)
#
# function -S setup
#     mkdir -p $path/{foo,bar}/functions
#
#     set -U fisher_prompt foo
#
#     # We want to test that functions/fish_prompt has precedence over ./fish_prompt
#
#     echo "echo foo" > $path/foo/functions/fish_prompt.fish
#     echo "echo norf" > $path/foo/fish_prompt.fish
#
#     # ./fish_prompt must be set as there isn't a functions/fish_prompt
#
#     echo "echo bar" > $path/bar/fish_prompt.fish
# end
#
# function -S teardown
#     rm -rf $path
# end
#
# test "$TESTNAME - source prompt inside functions by default"
#     (__fisher_prompt_reset $path/foo) = foo
# end
#
# test "$TESTNAME - source prompt at the root if none found inside functions"
#     (__fisher_prompt_reset $path/bar) = bar
# end
#
#
# test "$TESTNAME - source prompt at the root if none found inside functions"
#     (__fisher_prompt_reset $path/bar) = bar
# end
