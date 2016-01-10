function __fisher_alias -a value -d "Define command aliases"
    switch "$value"
        case ""
            if test -z "$fisher_alias"
                return 1
            end

            printf "%s\n" $fisher_alias | sed 's/[=,]/ /g'

        case \*
            for value in $argv
                if contains -- $fisher_alias $value
                    continue
                end

                set -g fisher_alias $fisher_alias $value

                set -l index $fisher_cache/.index

                if not test -e $index
                    continue
                end

                for alias in (__fisher_alias)
                    switch $alias
                        case install\*
                            __fisher_complete_remote $alias

                        case update\* uninstall\*
                            __fisher_complete_cache $alias
                    end
                end
            end
    end
end
