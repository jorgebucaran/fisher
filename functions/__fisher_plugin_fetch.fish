function -S __fisher_plugin_fetch
    set -l plugins
    set -l fetched

    for item in $argv
        if not set item (__fisher_plugin_validate "$item")
            printf "fisher: '%s' is not a valid plugin\n" "$item" > $stderr
            debug "validate fail %s" "$item"
            continue
        end

        debug "validate ok %s" "$item"
        if contains -- "$item" $enabled
            if test -z "$option"
                set skipped $skipped "$item"
                debug "skip %s" "$item"
                continue
            end
        end

        switch "$item"
            case \*/\*
                set plugins $plugins "$item"
                debug "url or path %s" $item

            case \*
                if test -d "$fisher_cache/$item"
                    set -l url (__fisher_url_from_path "$fisher_cache/$item")

                    if test ! -z "$url"
                        set plugins $plugins "$url"
                    end

                    debug "cache %s" "$item"

                else
                    if test ! -s $fisher_cache/.index
                        if spin "__fisher_index_update" --error=/dev/null > /dev/null
                            debug "update index ok"
                        else
                            debug "update index fail"
                        end
                    end

                    if set -l url (fisher_search --url --name="$item" --index=$fisher_cache/.index)
                        set plugins $plugins "$url"
                        debug "name %s" $item

                    else
                        printf "fisher: I couldn't find '%s' in the index\n" $item > $stderr
                    end
                end
        end
    end

    for plugin in $plugins
        set -l name (echo $plugin | __fisher_name)
        set -l path $fisher_cache/$name

        switch "$plugin"
            case {https://,}gist.github.com\*
                debug "gist %s" $item

                if not set name (__fisher_gist_to_name $plugin)
                    printf "fisher: I could not find your gist\n" > $stderr
                    continue
                end
        end

        printf "%s\n" "$name"
        debug "plugin %s" "$name"

        if test ! -e $path -a ! -L $path
            if not set -q __fisher_fetch_status
                set -g __fisher_fetch_status
                printf "Installing plugin/s\n" > $stderr

            else if test "$__fisher_fetch_status" = "deep"
                printf "Installing dependencies\n" > $stderr
                set -g __fisher_fetch_status done
            end

            set fetched $fetched "$path"

            if test -d "$plugin"
                debug "link %s" "$plugin"
                command ln -sfF $plugin $path

            else
                debug "clone %s" "$plugin"
                fish -ic "
                    spin '
                        if __fisher_url_clone $plugin $path
                            printf \"      %-20s\n\" \"$name\"
                        end
                    ' > $stderr
                " &
            end
        end
    end

    if test ! -z "$plugins"
        while true
            set -l has_jobs (jobs)
            if test -z "$has_jobs"
                break
            end
        end
    end

    switch "$__fisher_fetch_status"
        case done deep
        case \*
            set __fisher_fetch_status deep
    end

    for path in $fetched
        for file in $path/{fishfile,bundle}
            if test -s $file
                __fisher_plugin_fetch (__fisher_file < $file)
            end
        end
    end

    set -e __fisher_fetch_status
end
