set -g fisher_file $fisher_config/fishfile
set -g fisher_cache $fisher_config/cache
set -g fisher_binds $fisher_config/key_bindings.fish

set -g fish_function_path {$fisher_config,$fisher_home}/functions $fish_function_path
set -g fish_complete_path {$fisher_config,$fisher_home}/completions $fish_complete_path

for file in $fisher_config/conf.d/*.fish
    source $file
end
