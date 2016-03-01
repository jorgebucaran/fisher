function fisher_install -d "Install plugins"
    set -l plugins
    set -l option
    set -l stdout /dev/stdout
    set -l stderr /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set plugins $plugins $2

            case f force
                set option force

                if test ! -z "$2"
                    set plugins $plugins $2
                end

            case q quiet
                set stdout /dev/null
                set stderr /dev/null

            case h
                printf "Usage: fisher install [<plugins>] [--force] [--quiet] [--help]\n\n"
                printf "    -f --force    Reinstall given plugin/s\n"
                printf "    -q --quiet    Enable quiet mode\n"
                printf "    -h --help     Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_install -h > /dev/stderr
                return 1
        end
    end

    set -l link
    set -l time (date +%s)
    set -l count 0
    set -l index 1
    set -l total (count $plugins)
    set -l skipped
    set -l indicator "▸"

    set -l IFS \t

    if set -q plugins[1]
        printf "%s\n" $plugins
    else
        __fisher_file

    end | while read -l item
        debug "Validate %s" $item

        if not set item (__fisher_plugin_validate $item)
            debug "Validate fail %s" $item
            printf "fisher: '%s' is not a valid name, path or URL.\n" $item > $stderr
            continue
        end

        debug "Validate ok %s" $item

        switch "$item"
            case https://gist.github.com\*
                debug "Gist %s" $item

                if set -l name (__fisher_gist_to_name $item)
                    printf "%s\t%s\n" $item $name
                else
                    set total (math $total - 1)
                    printf "fisher: Repository '%s' not found.\n" $item > $stderr
                end

            case \*/\*
                debug "URL or path %s" $item

                printf "%s\t%s\n" "$item" (printf "%s\n" "$item" | __fisher_name)

            case \*
                if test -d $fisher_cache/$item
                    debug "Cache %s" \$fisher_cache/$item
                    printf "%s\t%s\n" (__fisher_url_from_path $fisher_cache/$item) $item

                else
                    if functions -q "$item"
                        if set -l path (__fisher_function_to_plugin $item)
                            printf "%s\t%s" "$path" $item
                            continue
                        end
                    end

                    if test ! -s $fisher_cache/.index
                        printf "$indicator Updating Index %s\n" $name > $stderr

                        if spin "__fisher_index_update" --error=/dev/null -f "  @\r" > /dev/null
                            debug "Update index ok"
                        else
                            debug "Update index fail"
                        end
                    end

                    if set -l url (fisher_search --url --name=$item --index=$fisher_cache/.index)
                        debug "Index %s" $item
                        printf "%s\t%s\n" $url $item
                    else
                        set total (math $total - 1)
                        printf "fisher: '%s' not found or index out of date.\n" $item > $stderr
                    end
                end
        end

    end | while read -l url name
        if contains -- $name (fisher_list $fisher_file)
            if test -z "$option"
                set total (math $total - 1)
                set skipped $skipped $name
                continue
            end
        end

        printf "$indicator Installing " > $stderr

        switch $total
            case 0 1
                printf "%s\n" $name > $stderr

            case \*
                printf "(%s of %s) %s\n" $index $total $name > $stderr
                set index (math $index + 1)
        end

        command mkdir -p $fisher_config/{functions,completions,conf.d,man} $fisher_cache

        set -l path $fisher_cache/$name

        if test ! -e $path
            if test -d "$url"
                debug "Link %s" $url

                command ln -sfF $url $path
            else
                debug "Clone %s" $url

                if not spin "__fisher_url_clone $url $path" --error=$stderr -f "  @\r"
                    continue
                end
            end
        end

        set -l deps (__fisher_deps_install "$path")

        if test "$deps" -gt 0
            debug "Install deps ok"
        end

        if not __fisher_path_make "$path" --quiet
            set total (math $total - 1)
            continue
        end

        __fisher_plugin_enable "$name" "$path"

        set count (math $count + 1 + "0$deps")
    end

    set time (math (date +%s) - $time)

    if test ! -z "$skipped"
        printf "%s plugin/s skipped (%s)\n" (
            count $skipped) (printf "%s\n" $skipped | paste -sd ' ' -) > $stdout
    end

    if test "$count" -le 0
        printf "No plugins were installed.\n" > $stdout
        return 1
    end

    debug "Reset completions and key bindings start"

    __fisher_complete_reset
    __fisher_key_bindings_reset

    debug "Reset completions and key bindings ok"

    printf "%d plugin/s installed in %0.fs\n" $count $time > $stdout
end
