function __fisher_prompt_reset
    set -U fisher_prompt

    # To reset the prompt, remove any data in fisher_prompt and source any existing
    # fish_prompt file as follows. First, look inside functions/ inside each of the
    # given paths. If none are given, look in the user fish configuration. If none
    # is found, source the default prompt inside __fish_datadir/functions.

    set argv $argv (__fisher_xdg --config)/fish $__fish_datadir

    for prompt in $argv/functions/fish_prompt.fish
        if test -s $prompt
            debug "Reset prompt %s" $prompt

            source $prompt
            return
        end
    end
end
