set fisher_cache $fisher_config/cache
set fisher_index https://raw.githubusercontent.com/fisherman/fisher-index/master/INDEX

set fisher_error_log $fisher_cache/.debug_log

set fish_function_path {$fisher_config,$fisher_home}/functions $fish_function_path
set fish_complete_path {$fisher_config,$fisher_home}/completions $fish_complete_path

for file in $fisher_config/functions/*.config.fish
    source $file
end
