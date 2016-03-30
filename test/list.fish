set -l path $DIRNAME/.t-$TESTNAME-(random)
set -l fisherman_url https://github.com/fisherman/fisherman

function -S setup
    mkdir -p $path/cache/{foo,bar,baz,norf} $path/theme

    ln -s $path/theme $path/cache/theme

    printf "%s\n" foo bar baz theme > $path/fishfile

    set -g fisher_cache $path/cache
    set -g fisher_file $path/fishfile
    set -U fisher_prompt theme

    source $DIRNAME/helpers/git-ls-remote.fish
end

function -S teardown
    rm -rf $path
    functions -e git
end

test "$TESTNAME - Append @ to linked theme"
    (fisher list | sed -n '/@.*/p') = "@ theme"
end

test "$TESTNAME - Indent plugins to match indent when links or prompts are installed"
    (fisher list | sed -n '/  .*/p' | xargs) = "foo bar baz"
end

test "$TESTNAME - Do not display disabled plugins"
    -z (
        rm $path/fishfile
        fisher list
        )
end

test "$TESTNAME - Show active / enabled plugins/prompts with fisher list=enabled"
    foo bar baz theme = (fisher list --enabled)
end

test "$TESTNAME - Show disabled/inactive plugins/prompts with fisher list=disabled"
    (fisher list --disabled) = norf
end

test "$TESTNAME - Parse a fishfile and display plugins with fisher list=<file>"
    foo bar baz theme = (fisher list - < $fisher_file)
end
