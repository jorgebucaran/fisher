# Reset Fisherman's configuration state.

set -g fisher_config $argv
source $fisher_home/config.fish

set -U fisher_prompt
set -g plugins $DIRNAME/fixtures/plugins
set -g fisher_index file://$plugins/index

__fisher_index_update

function -S __fisher_url_clone -a url path
    cp -rf (echo $url | sed "s|https://github.com/|$plugins/|") $path
end

function wait
    eval $argv
end
