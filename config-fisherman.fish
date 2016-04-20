# If fisher_home is not provided, use the global directory:
set -q fisher_home; or set -g fisher_home (dirname (status -f))/../fisherman

# If fisher_config is not provided, set it up:
set -q fisher_config
or if test ! -z "$XDG_CONFIG_HOME"
    set -g fisher_config $XDG_CONFIG_HOME/fisherman
else
    # if XDG home is unset or empty, use ~/.config as a fallback
    set -g fisher_config ~/.config/fisherman
end

# To not break fish, we need to make sure the config dir exists:
if test ! -d "$fisher_config"
    echo "Setting up Fisherman config dir..."
    mkdir -p "$fisher_config/cache"
    touch "$fisher_config/fishfile"
    echo "Done."
end

source "$fisher_home/config.fish"
