function fisher_mock_config -a path index
    set -g fisher_config $path/config
    set -g fisher_cache $fisher_config/cache
    set -g fisher_index "file://$index"
end
