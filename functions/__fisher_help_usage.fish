function __fisher_help_usage -a value
    if test -z "$value"
        set -e value
        sed -E 's/^ *([^ ]+).*/\1/' | while read -l command
            if functions -q fisher_$command
                set value $command $value
            end
        end
    end

    for command in $value
        fisher $command -h
    end
end
