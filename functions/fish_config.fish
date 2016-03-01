function fish_config -d "Launch fish's web based configuration" -a tab
    set -l config ~/.config

    if set -q XDG_CONFIG_HOME
        set config $XDG_CONFIG_HOME
    end

    set -l file $config/fish/functions/fish_prompt.fish
    set -l sum_before (cksum $file ^ /dev/null | awk '{ print $1 + $2 }')

    eval $__fish_datadir/tools/web_config/webconfig.py $tab

    if test ! -z "$fisher_prompt"
        set -l sum_after (cksum $file ^ /dev/null | awk '{ print $1 + $2 }')

        debug "fish_prompt check sum before: %s" $sum_before
        debug "fish_prompt check sum after: %s" $sum_after

        if test "$sum_before" != "$sum_after"
            debug "Uninstall %s" "$fisher_prompt"
            fisher_uninstall "$fisher_prompt" -q
        end
    end
end
