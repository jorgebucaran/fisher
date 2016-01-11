set -g fisher_cache $fisher_config/cache
set -g fisher_share $fisher_config/share
set -g fisher_index https://raw.githubusercontent.com/fisherman/fisher-index/master/INDEX

set -g fisher_error_log $fisher_cache/.debug_log

set -g fish_function_path {$fisher_config,$fisher_home}/functions $fish_function_path
set -g fish_complete_path {$fisher_config,$fisher_home}/completions $fish_complete_path

for file in $fisher_config/conf.d/*.fish
    source $file
end
