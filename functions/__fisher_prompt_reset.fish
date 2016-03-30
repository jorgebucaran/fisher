function __fisher_prompt_reset
    set -U fisher_prompt

    set argv $argv (__fisher_xdg --config)/fish $__fish_datadir

    for prompt in $argv/functions/fish_prompt.fish
        if test -s $prompt
            debug "reset prompt %s" $prompt

            source $prompt
            return
        end
    end
end
