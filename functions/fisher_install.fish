function fisher_install -d "Install plugins (i)"
    set -l items
    set -l option
    set -l stdout /dev/stdout
    set -l stderr /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set items $items $2

            case q quiet
                set stdout /dev/null
                set stderr /dev/null

            case h
                printf "Usage: fisher install [<plugins>] [--quiet] [--help]\n\n"
                printf "    -q --quiet     Enable quiet mode\n"
                printf "    -h --help      Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option\n" $1 > /dev/stderr
                fisher_install -h > /dev/stderr
                return 1
        end
    end

    command mkdir -p $fisher_cache $fisher_config/{functions,completions,conf.d,man}

    set -l time (date +%s)
    set -l count 0
    set -l index 1
    set -l skipped
    set -l enabled (fisher_list --enabled)

    if test -z "$items"
        __fisher_file | read -az items
    end

    set -l plugins (__fisher_plugin_fetch $items | awk '!seen[$0]++')

    for plugin in $plugins
        set -l path $fisher_cache/$plugin

        if test -d $path
            __fisher_path_make "$path" --quiet
            __fisher_plugin_enable "$plugin" "$path"

            set count (math $count + 1)
        end
    end

    set time (math (date +%s) - $time)

    if test ! -z "$skipped"
        printf "%s plugin/s skipped (%s)\n" (
            count $skipped) (printf "%s\n" $skipped | paste -sd ' ' -) > $stdout
    end

    if test "$count" -le 0
        printf "No plugins were installed\n" > $stdout
        return 1
    end

    __fisher_complete_reset
    __fisher_key_bindings_reset

    debug "complete and key binds reset"

    printf "%d plugin/s installed (%0.fs)\n" $count $time > $stdout
end
