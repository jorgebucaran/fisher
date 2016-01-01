function fisher_install -d "Enable / Install Plugins"
    set -l items
    set -l error /dev/stderr

    getopts $argv | while read -l 1 2
        switch "$1"
            case _
                set items $items $2

            case q quiet
                set error /dev/null

            case h help
                printf "usage: fisher install [<name | url> ...] [--quiet] [--help]\n\n"

                printf "    -q --quiet  Enable quiet mode\n"
                printf "     -h --help  Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option\n" $1 >& 2
                fisher_install --help >& 2
                return 1
        end
    end

    set -l count 0
    set -l duration (date +%s)
    set -l total (count $items)

    if set -q items[1]
        printf "%s\n" $items
    else
        fisher --file=-

    end | fisher --validate | while read -l item

        switch "$item"
            case \*/\*
                printf "%s %s\n" $item (
                    if not fisher_search --url=$item --field=name
                        printf "%s" $item | sed -E '
                            s/.*\/(.*)/\1/
                            s/^(plugin|theme|pkg|fish)-//'
                    end)

            case \*
                if set -l url (fisher_search --name=$item --field=url)
                    printf "%s %s\n" $url $item

                else if test -d $fisher_cache/$item
                    printf "%s %s\n" (git -C $fisher_cache/$item ls-remote --get-url) $item

                else
                    printf "fisher: '%s' not found\n" $item > $error
                end
        end

    end | while read -l url name

        printf "Installing " > $error

        switch $total
            case 0 1
                printf ">> %s\n" $name > $error

            case \*
                printf "(%s of %s) >> %s\n" (math 1 + $count) $total $name > $error
        end

        mkdir -p $fisher_config/{cache,functions,completions,man}

        set -l path $fisher_cache/$name

        if not test -e $path
            if not wait --spin=pipe --log=$fisher_error_log "
                git clone --quiet --depth 1 $url $path"

                printf "fisher: Repository not found: '%s'\n" $url > $error
                continue
            end
        end

        set -l bundle $path/fishfile

        if test -e $path/bundle
            set bundle $path/bundle
        end

        if test -e $bundle
            printf "Resolving dependencies in %s\n" $name/(basename $bundle) > $error

            set -l deps (fisher --file=$bundle \
              | fisher_install ^&1 | sed -En 's/([0-9]+) plugin\/s.*/\1/p')

            set count (math $count + 0$deps)
        end

        if test -s $path/Makefile -o -s $path/makefile
            pushd $path
            if not make > /dev/null ^ $error
                popd
                printf "fisher: Can't make '%s'\n" $name > $error
                continue
            end
            popd
        end

        if test -e $path/fish_prompt.fish -o -e $path/fish_right_prompt.fish
            rm -f $fisher_config/functions/{fish_prompt,fish_right_prompt}.fish
        end

        for file in $path/{*,functions{/*,/**/*}}.fish
            set -l base (basename $file)
            switch $base
                case {init,uninstall}.fish
                    set base $name.config.$base
            end
            cp -f $file $fisher_config/functions/$base
        end

        source $fisher_config/functions/$name.fish > /dev/null ^& 1

        cp -f $path/completions/*.fish $fisher_config/completions/ ^ /dev/null

        for n in (seq 9)
            if test -d $path/man/man$n
                mkdir -p $fisher_config/man/man$n
            end
            cp -f $path/man/man$n/*.$n $fisher_config/man/man$n/ ^ /dev/null
        end

        set count (math $count + 1)

        set -l file $fisher_config/fishfile

        if test -s $file
            if fisher --file=$file  | grep -Eq "^$name\$|^$url\$"
                continue
            end
        end

        touch $file

        if not fisher_search --name=$name --field=name --quiet
            set name $url
        end

        printf "%s\n" "$name" >> $file

    end

    printf "%d plugin/s installed (%0.fs)\n" (math $count) (
        math (date +%s) - $duration) > $error

    if not test $count -gt 0
        return 1
    end
end
