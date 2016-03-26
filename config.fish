# If fisher_home is not provided, use the directory of this file:
set -q fisher_home; or set -g fisher_home (dirname (status -f))

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

set -g fisher_file $fisher_config/fishfile
set -g fisher_cache $fisher_config/cache
set -g fisher_binds $fisher_config/key_bindings.fish

set -g fish_function_path {$fisher_config,$fisher_home}/functions $fish_function_path
set -g fish_complete_path {$fisher_config,$fisher_home}/completions $fish_complete_path

for file in $fisher_config/conf.d/*.fish
    source $file
end
