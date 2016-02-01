function __fisher_help_parse
    sed -nE  's/^ *(-(.))?,? *--([^ =]+) *(.*)$/\4;\3;\2/p'
end
