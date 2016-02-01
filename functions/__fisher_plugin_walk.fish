function __fisher_plugin_walk -a plugin path
    for file in $path/{*,{conf.d,modules}/*,functions/**}.{fish,load} $path/completions/*.fish
        set -l name (basename $file .fish)
        set -l base $name.fish

        switch $file
            case \*/{fish_user_,}key_bindings.fish
                printf "%s %s %s\n" --bind $file

            case \?\*/uninstall.fish
                printf "%s %s\n" --uninstall $file

            case \?\*/{conf.d,modules}/\?\* \?\*/\*config.fish \?\*/{,before.}init.fish \*/$plugin.load
                switch "$base"
                    case \*$plugin\*
                    case \*
                        set base $plugin.$base
                end

                printf "%s %s %s\n" --source $file conf.d/$base

            case \*/completions/$plugin.fish
                printf "%s %s %s\n" --source $file completions/$base

            case \*
                printf "%s %s %s %s\n" --source $file functions/$base $name
        end
    end

    for prefix in functions scripts ""
        for file in $path/$prefix/*.{py,rb,php,pl,awk,sed}
            set -l base (basename $file)

            if test -z "$prefix"
                set prefix functions
            end

            printf "%s %s %s\n" -- $file $prefix/$base
        end
    end

    for n in (seq 9)
        for file in $path/man/man$n/*.$n
            printf "%s %s %s\n" --man $file man/man$n/(basename $file)
        end
    end
end
