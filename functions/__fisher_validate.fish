function __fisher_validate -d "Validate a name, url or path"
    set -l id "[A-Za-z0-9_]+([.-]?[A-Za-z0-9_])*"

    if not set -q fisher_default_host
        set fisher_default_host https://github.com
    end

    while read -lp "" item
        switch "$item"
            case \*..\* /. /
                continue
        end

        if test -e "$item"
            if test $item = $HOME
                continue
            end

            if test -f "$item"
                set item (dirname $item)
            end

            if not printf "%s\n" $item | grep "^\/"
                printf "$PWD/%s/%s" (dirname $item) (basename $item)
            end | sed -E 's|^/|file:///|;s|[./]*$||'

        else
            printf "%s\n" $item | sed -En "
                s#plg?ug?i?n#plugin#
                s#oh?my?i?f[iy]?h?si?h?#oh-my-fish#
                s#/\$##
                s#\.git\$##
                s#^(https?):*/* *(.*\$)#\1://\2#p
                s#^(@|(gh[:/])|(github(.com)?[/:]))/?($id)/($id)\$#https://github.com/\5/\7#p
                s#^(bb[:/])/*($id)/($id)\$#https://bitbucket.org/\2/\4#p
                s#^(gl[:/])/*($id)/($id)\$#https://gitlab.com/\2/\4#p
                s#^(omf[:/])/*($id)\$#https://github.com/oh-my-fish/\2#p
                s#^($id)/($id)\$#$fisher_default_host/\1/\3#p
                /^file:\/\/\/.*/p
                /^[a-z]+([._-]?[a-z0-9]+)*\$/p"
        end
    end
end
