function setup
    set -g XDG_CONFIG_HOME config
    set -g XDG_DATA_HOME data
    set -g XDG_CACHE_HOME cache
end

test "$TESTNAME - Return ~/.config if XDG_CONFIG_HOME not set" (
    set -e XDG_CONFIG_HOME
    __fisher_xdg --config) = $HOME/.config
end

test "$TESTNAME - Return ~/.cache if XDG_CACHE_HOME not set" (
    set -e XDG_CACHE_HOME
    __fisher_xdg --cache) = $HOME/.cache
end

test "$TESTNAME - Return ~/.local/share if XDG_DATA_HOME not set" (
    set -e XDG_DATA_HOME
    __fisher_xdg --data) = $HOME/.local/share
end

for flag in config data cache
    test "$TESTNAME - Flag --$flag is equivalent to --$flag-home"
        (__fisher_xdg --$flag) = (__fisher_xdg --$flag-home)
    end

    test "$TESTNAME - Flag --$flag returns XDG-$flag-HOME if set"
        (__fisher_xdg --$flag) = $flag
    end
end
