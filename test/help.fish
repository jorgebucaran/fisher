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

test "help --all shows commands and guides"
    ! -z (fisher help --all | grep -E 'Available Commands:$|Other Documentation:$' | xargs)
end

test "help --guides shows guides"
    ! -z (fisher help --guides | grep -E 'Other Documentation:$' | xargs)
end

test "help --usage shows command usage info"
    (fisher help --usage=help) = (fisher help -h)
end

for i in $sections
    test "read fisher-<name> man pages"
        (fisher help $name | xargs) = $name
    end
end

test "display usage help"
    (fisher help --commands=bare | fisher help --usage | xargs
        ) = "usage: fisher help [<keyword>] [--all] [--guides] [--help] -a --all List available documentation -g --guides List available guides -u --usage[=<cmd>] Display command usage -h --help Show usage help usage: fisher install [<plugins>] [--quiet] [--help] -q --quiet Enable quiet mode -h --help Show usage help usage: fisher search [<plugins>] [--select=<source>] [--quiet] [--or|--and] [--field=<field>] [--help] -s --select=<source> Select all, cache or remote plugins -f --field=<field> Filter by name, url, info, tag or author -o --or | -a --and Join query with AND/OR operator -q --quiet Enable quiet mode -h --help Show usage help usage: fisher uninstall [<plugins>] [--force] [--quiet] [--help] -f --force Delete copy from cache -q --quiet Enable quiet mode -h --help Show usage help usage: fisher update [<plugins>] [--quiet] [--help] -q --quiet Enable quiet mode -h --help Show usage help"
end
