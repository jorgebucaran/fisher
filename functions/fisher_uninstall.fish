function fisher_uninstall -d "Uninstall Plugins"
    set -l error /dev/stderr
    set -l items
    set -l option

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set items $items $2

            case f force
                set option $option force

            case q quiet
                set error /dev/null

            case help
                set option help

            case h
                printf "usage: fisher uninstall [<plugins>] [--force] [--quiet] [--help]\n\n"

                printf "    -f --force  Delete copy from cache \n"
                printf "    -q --quiet  Enable quiet mode      \n"
                printf "     -h --help  Show usage help        \n"
                return

            case \*
                printf "fisher: Ahoy! '%s' is not a valid option\n" $1 >& 2
                fisher_uninstall -h >& 2
                return 1
        end
    end

    switch "$option"
        case help
            fisher help uninstall
            return
    end

    set -l time (date +%s)
    set -l count 0
    set -l index 1
    set -l total (count $items)

    if set -q items[1]
        printf "%s\n" $items
    else
        __fisher_file /dev/stdin

    end | __fisher_validate | __fisher_resolve_plugin $error | while read -l path

        set -l name (printf "%s\n" $path | __fisher_name)

        if not contains -- $name $fisher_plugins
            if not contains -- force $option
                continue
            end
        end

        printf "Uninstalling " > $error

        switch $total
            case 0 1
                printf ">> %s\n" $name > $error

            case \*
                printf "(%s of %s) >> %s\n" $index $total $name > $error
                set index (math $index + 1)
        end

        __fisher_plugin --disable $name $path

        git -C $path ls-remote --get-url ^ /dev/null | __fisher_validate | read -l url

        switch force
            case $option
                rm -rf $path
        end

        set count (math $count + 1)

        set -l file $fisher_config/fishfile

        if not __fisher_file $file | grep -Eq "^$name\$|^$url\$"
            continue
        end

        set -l tmp (mktemp -t fisher.XXX)

        if not sed -E '/^ *'(printf "%s|%s" $name $url | sed 's|/|\\\/|g'
        )'([ #].*)*$/d' < $file > $tmp
            rm -f $tmp
            printf "fisher: Could not remove '%s' from %s\n" $name $file > $error
            return 1
        end

        mv -f $tmp $file
    end

    set time (math (date +%s) - $time)

    if test $count = 0
        printf "No plugins were uninstalled.\n" > $error
        return 1
    end

    printf "Aye! %d plugin/s uninstalled in %0.fs\n" > $error $count $time
end
