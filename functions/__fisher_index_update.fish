function __fisher_index_update -a timeout
    if test -z "$timeout"
        set timeout 5

        if set -q fisher_timeout
            set timeout "0$fisher_timeout"
        end
    end

    debug "Update index with timeout '%.1f'" $timeout

    set -l url $fisher_index
    set -l index $fisher_cache/.index.tmp

    if test -z "$url"
        # Force the server to return the latest copy of the index using a fake query string.
        set url https://raw.githubusercontent.com/fisherman/fisher-index/master/index\?(date +%s)
    end

    if not curl --max-time $timeout -sS "$url" > $index
        debug "Update index fail"

        command rm -f $index
        return 1
    end

    debug "Update index complete"

    command mv -f $index $fisher_cache/.index
end
