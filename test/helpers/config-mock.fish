# Reset Fisherman's configuration state.

if functions -q debug
    functions -c debug debug_copy
end

set -g fisher_config $argv

source $fisher_home/config.fish

if functions -q debug
    functions -e debug
    functions -c debug_copy debug
    functions -e debug_copy
end

set -U fisher_prompt
set -g plugins $DIRNAME/fixtures/plugins
set -g fisher_index file://$plugins/index

__fisher_index_update

function -S __fisher_url_clone -a url path
    cp -rf (echo $url | sed "s|https://github.com/|$plugins/|") $path
end

function spin
    eval $argv
end
