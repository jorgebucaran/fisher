test "display help help"
    (fisher help --help | xargs) = "usage: fisher help [<keyword>] [--all] [--guides] [--usage[=<command>]] [--help] -a --all List commands and guides -g --guides List documentation guides -u --usage[=<command>] Display command usage help -h --help Show usage help"
end

test "display install help"
    (fisher install --help | xargs) = "usage: fisher install [<name | url> ...] [--quiet] [--help] -q --quiet Enable quiet mode -h --help Show usage help"
end

test "display search help"
    (fisher search --help | xargs) = "usage: fisher search [<name | url>] [--select=<source>] [--field=<field>] [--or|--and] [--quiet] [--help] -s --select=<source> Select all, cache or remote plugins -f --field=<field> Filter by name, url, info, tag or author -a --and Join query with AND operator -o --or Join query with OR operator -q --quiet Enable quiet mode -h --help Show usage help"
end

test "display uninstall help"
    (fisher uninstall --help | xargs) = "usage: fisher uninstall [<name | url> ...] [--all] [--force] [--quiet] [--help] -a --all Uninstall all plugins -f --force Delete copy from cache -q --quiet Enable quiet mode -h --help Show usage help"
end

test "display update help"
    (fisher update --help | xargs) = "usage: fisher update [<name | url> ...] [--self] [--cache] [--path=<path>] [--quiet] [--help] -s --self Update Fisherman -c --cache Update cached plugins --path=<path> Update repository at given path -q --quiet Enable quiet mode -h --help Show usage help"
end
