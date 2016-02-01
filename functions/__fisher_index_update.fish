function __fisher_index_update
    set -l timeout 5

    if set -q fisher_timeout
        set timeout "0$fisher_timeout"
    end

    set -l index $fisher_cache/.index.tmp

    # We pass a random query string after the URL to force the the
    # server (GitHub) to always return the latest copy of the index.

    set -l query $fisher_index

    switch "$fisher_index"
        case https://\*
            set query $fisher_index\?(date +%s)
    end

    if not curl --max-time $timeout -sS "$query" > $index
        rm -f $index
        return 1
    end

    mv -f $index $fisher_cache/.index
end
