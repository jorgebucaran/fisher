function __fisher_xdg -a dir
    set -l config $HOME/.config
    set -l data $HOME/.local/share
    set -l cache $HOME/.cache

    switch "$dir"
        case --config{,-home}
            if set -q XDG_CONFIG_HOME
                set config $XDG_CONFIG_HOME
            end
            printf "%s\n" $config

        case --data{,-home}
            if set -q XDG_DATA_HOME
                set data $XDG_DATA_HOME
            end
            printf "%s\n" $data

        case --cache{,-home}
            if set -q XDG_CACHE_HOME
                set cache $XDG_CACHE_HOME
            end
            printf "%s\n" $cache
    end
end
