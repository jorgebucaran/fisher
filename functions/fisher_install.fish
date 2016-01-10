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
        __fisher_file -
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
                set index (math $index + 1)
                printf "(%s of %s) >> %s\n" $index $total $name > $error
        end

        mkdir -p $fisher_config/{cache,functions,completions,conf.d,man}

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

        if test -L $path
            set option link
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

        for file in $path/{*,functions{/*,/**}}.fish
            set -l base (basename $file)

            switch $base
                case {$name,fish_{,right_}prompt}.fish
                    source $file

                case {init,uninstall}.fish
                    set base $name.(basename $base .fish).config.fish
            end

            switch $base
                case \*\?.config.fish
                    if test "$option" = link
                        ln -sfF $file $fisher_config/conf.d/$base
                    else
                        cp -f $file $fisher_config/conf.d/$base
                    end

                case \*
                    if test "$option" = link
                        ln -sfF $file $fisher_config/functions/$base
                    else
                        cp -f $file $fisher_config/functions/$base
                    end
            end
        end

        if test "$option" = link
            for file in $path/completions/*.fish
                ln -sfF $file $fisher_config/completions/(basename $file)
            end
        else
            cp -f $path/completions/*.fish $fisher_config/completions/ ^ /dev/null
        end

        for n in (seq 9)
            if test -d $path/man/man$n
                mkdir -p $fisher_config/man/man$n
            end

            for file in $path/man/man$n/*.$n
                if test "$option" = link
                    ln -sfF $file $fisher_config/man/man$n
                else
                    cp -f $file $fisher_config/man/man$n
                end
            end
        end

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
