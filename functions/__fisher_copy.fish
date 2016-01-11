function __fisher_copy -a option source target -d "cp/ln wrapper"
    if test "$option" = link
        ln -sfF $source $target
    else
        cp -f $source $target
    end
end
