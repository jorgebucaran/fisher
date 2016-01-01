set -l name foo
set -l path $DIRNAME/.$TESTNAME.test
set -l sections 1 5 7

function -S setup
    set -gx MANPATH $path/man
    for i in $sections
        if not mkdir -p $MANPATH/man$i
            return
        end
        echo $name > $MANPATH/man$i/fisher-$name.$i
    end
end

function -S teardown
    rm -rf $path
end


test "help wraps `fisher` w/o arguments"
    (fisher help) = (fisher)
end

test "help --all shows commands and guides"
    ! -z (fisher help --all | grep -E 'Fisherman commands:$|Fisherman guides:$' | xargs)
end

test "help --guides shows guides"
    ! -z (fisher help --guides | grep -E 'Fisherman guides:$' | xargs)
end

test "help --usage shows command usage info"
    (fisher help --usage=help) = (fisher help --help)
end

for i in $sections
    test "read fisher-<name> man pages"
        (fisher help $name | xargs) = $name
    end
end
