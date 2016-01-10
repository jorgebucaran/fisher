function fisher_install -d "Install Plugins"
    set -l items
    set -l option
    set -l error /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set items $items $2

            case q quiet
                set error /dev/null

            case help
                set option help

            case h
                printf "usage: fisher install [<plugins>] [--quiet] [--help]\n\n"

                printf "    -q --quiet  Enable quiet mode\n"
                printf "     -h --help  Show usage help\n"
                return

            case \*
                printf "fisher: Ahoy! '%s' is not a valid option\n" $1 >& 2
                fisher_install -h >& 2
                return 1
        end
    end

    switch "$option"
        case help
            fisher help install
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
    end | __fisher_validate | while read -l item

        switch "$item"
            case \*/\*
                printf "%s %s\n" $item (
                    if not fisher_search --name --url=$item
                        printf "%s\n" $item | __fisher_name
                    end)

            case \*
                if set -l url (fisher_search --name=$item --url)
                    printf "%s %s\n" $url $item

                else if test -d $fisher_cache/$item
                    printf "%s %s\n" (git -C $fisher_cache/$item ls-remote --get-url) $item

                else
                    printf "fisher: '%s' path not found\n" $item > $error
                end
        end

    end | while read -l url name

        printf "Installing " > $error

        switch $total
            case 0 1
                printf ">> %s\n" $name > $error

            case \*
                printf "(%s of %s) >> %s\n" $index $total $name > $error
                set index (math $index + 1)
        end

        mkdir -p $fisher_config/{functions,completions,conf.d,man}
        mkdir -p $fisher_cache $fisher_share

        set -l path $fisher_cache/$name

        switch "$url"
            case file:///\*
                if test ! -e $path
                    ln -sfF (printf "%s\n" $url | sed 's|file://||') $path
                end

            case \*
                if test ! -e $path
                    if not wait --spin=pipe --log=$fisher_error_log "
                        git clone --quiet --depth 1 $url $path"

                        printf "fisher: Repository not found: '%s'\n" $url > $error

                        switch "$url"
                            case \*oh-my-fish\*
                                printf "Did you miss a 'plugin-' or 'theme-' prefix?\n" > $error
                        end

                        continue
                    end
                end
        end

        set -l bundle $path/fishfile

        if test -e $path/bundle
            set bundle $path/bundle
        end

        if test -e $bundle
            printf "Resolving dependencies in %s\n" $name/(basename $bundle) > $error

            set -l deps (__fisher_file $bundle \
              | fisher_install ^&1 \
              | sed -En 's/([0-9]+) plugin\/s.*/\1/p')

            set count (math $count + 0$deps)
        end

        if test -s $path/Makefile -o -s $path/makefile
            pushd $path
            if not make > /dev/null ^ $fisher_error_log
                cat $fisher_error_log
                popd
                continue
            end
            popd
        end

        if test -e $path/fish_prompt.fish -o -e $path/fish_right_prompt.fish
            rm -f $fisher_config/functions/fish_{,right_}prompt.fish
            functions -e fish_{,right_}prompt
        end

        __fisher_plugin --enable $name $path

        set count (math $count + 1)

        set -l file $fisher_config/fishfile

        touch $file

        set -l item $name

        if fisher_search --name=$name --and --tag=local --quiet
            set item $url
        end

        if test -s $file
            if __fisher_file $file | grep -Eq "^$item\$"
                continue
            end
        end

        printf "%s\n" "$item" >> $file
    end

    set time (math (date +%s) - $time)

    if test "$count" = 0
        printf "No plugins were installed.\n" > $error
        return 1
    end

    printf "Aye! %d plugin/s installed in %0.fs\n" $count $time > $error
end
