set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/{left,right,both,none}

    # In Fisherman everything is a plugin, but prompts are handled with special care behind
    # the scenes. A plugin is called a prompt if it has either a fish_prompt or fish_right_
    # prompt. Other files often included with prompt plugins such as fish_greeting or fish_
    # title are not taken into account.

    touch $path/left/fish_prompt.fish
    touch $path/right/fish_right_prompt.fish
    touch $path/both/fish_{,right_}prompt.fish
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Fail if neither fish_prompt / fish_right_prompt exists"
    (__fisher_path_is_prompt $path/none; printf $status) -eq 1
end

test "$TESTNAME - Succeed if fish_prompt exists"
    (__fisher_path_is_prompt $path/left; printf $status) -eq 0
end

test "$TESTNAME - Succeed if fish_right_prompt exists"
    (__fisher_path_is_prompt $path/right; printf $status) -eq 0
end

test "$TESTNAME - Succeed if both fish_{,right_}prompt exist"
    (__fisher_path_is_prompt $path/both; printf $status) -eq 0
end
