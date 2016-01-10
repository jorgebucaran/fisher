function __fisher_plugin -a enable name path -d "enable or disable plugins"
    set -l batch
    set -l option

    switch $enable
        case --disable
            set -e enable
    end

    if test -L $path
        set option link
    end

    for file in $path/*.load
        set -l base (basename $file).fish

        if set -q enable
            __fisher_copy "$option" $file $fisher_config/conf.d/$base
            set batch $batch $fisher_config/conf.d/$base
        else
            rm -f $fisher_config/conf.d/$base
        end
    end

    for file in $path/{*,{conf.d,modules}/*,functions/**}.fish
        set -l base (basename $file)

        if test $base = uninstall.fish
            if not set -q enable
                set batch $batch $file
            end

            continue
        end

        switch $file
            case \?\*/{conf.d,modules}/\?\*
                switch "$base"
                    case \*$name\*
                    case \*
                        set base $name.$base
                end

                if set -q enable
                    __fisher_copy "$option" $file $fisher_config/conf.d/$base
                    set batch $batch $fisher_config/conf.d/$base
                else
                    rm -f $fisher_config/conf.d/$base
                end

            case \*
                switch $base
                    case {$name,fish_{,right_}prompt}.fish
                        if set -q enable
                            source $file
                            __fisher_copy "$option" $file $fisher_config/functions/$base
                        else
                            functions -e (basename $base .fish)
                            rm -f $fisher_config/functions/$base

                            if test "$base" = fish_prompt.fish
                                source $__fish_datadir/functions/fish_prompt.fish ^ /dev/null
                            end
                        end

                    case \*\?.config.fish
                        if set -q enable
                            __fisher_copy "$option" $file $fisher_config/conf.d/$base
                            set batch $batch $fisher_config/conf.d/$base
                        else
                            rm -f $fisher_config/conf.d/$base
                        end

                    case {,before.}init.fish
                        set base $name.$base
                        if set -q enable
                            __fisher_copy "$option" $file $fisher_config/conf.d/$base
                            set batch $batch $fisher_config/conf.d/$base
                        else
                            rm -f $fisher_config/conf.d/$base
                        end

                    case \*
                        if set -q enable
                            __fisher_copy "$option" $file $fisher_config/functions/$base
                        else
                            rm -f $fisher_config/functions/$base
                        end
                end
        end
    end

    if not set -q fisher_share_extensions[1]
        set fisher_share_extensions py rb php pl awk sed
    end

    for file in $path/{share/,}*.$fisher_share_extensions
        set -l base (basename $file)

        switch $file
            case \*.md \*.fish
                continue
        end

        if set -q enable
            __fisher_copy "$option" $file $fisher_config/functions/$base
            __fisher_copy "$option" $file $fisher_share/$base
        else
            rm -f {$fisher_config/functions,$fisher_share}/$base
        end
    end

    for file in $path/completions/*.fish
        if set -q enable
            __fisher_copy "$option" $file $fisher_config/completions/(basename $file)
        else
            rm -f $fisher_config/completions/(basename $file)
        end
    end

    for n in (seq 9)
        if test -d $path/man/man$n
            mkdir -p $fisher_config/man/man$n
        end

        for file in $path/man/man$n/*.$n
            if set -q enable
                __fisher_copy "$option" $file $fisher_config/man/man$n
            else
                rm -f $fisher_config/man/man$n/(basename $file)
            end
        end
    end

    if set -q batch[1]
        for file in $batch
            source $file
        end
    end

    set -l index (contains -i -- $name $fisher_plugins)

    if set -q enable
        if test -z "$index"
            set -U fisher_plugins $fisher_plugins $name
        end
    else
        if test "$index" -ge 1
            set -e fisher_plugins[$index]
        end
    end

    complete -ec fisher

    source $fisher_home/completions/fisher.fish
end
