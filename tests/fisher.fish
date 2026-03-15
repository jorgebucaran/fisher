set --local BASENAME --regex -- '[^/]+$'

@echo (fisher --version)

@test "fisher install" (
    fisher install tests/ponyo >/dev/null 
) "$ponyo" = "pyon pyon"

@test "fisher list" (
    fisher list | string match $BASENAME | string join " "
) = "fisher fishtape ponyo"

@test "fisher list regex" (
    fisher list ponyo | string match $BASENAME
) = ponyo

@test "pyon pyon" (fish --command ponyo | string join " ") = "pyon pyon ponyo"

@test "fisher update" (
    fisher update tests/ponyo >/dev/null
) "$ponyo" = "pyon pyon"

@test "fisher update unchanged output is quiet" (
    set --local plugin (command mktemp -d)
    command mkdir -p $plugin/functions
    printf "function test_plugin\n    echo unchanged\nend\n" >$plugin/functions/test_plugin.fish
    fisher install $plugin >/dev/null
    set --local output (fisher update $plugin)
    fisher remove $plugin >/dev/null
    string match --quiet --entire -- "Updated" $output
    or echo ok
) = ok

@test "fisher update changed output" (
    set --local plugin (command mktemp -d)
    command mkdir -p $plugin/functions
    printf "function test_plugin\n    echo before\nend\n" >$plugin/functions/test_plugin.fish
    fisher install $plugin >/dev/null
    printf "function test_plugin\n    echo after\nend\n" >$plugin/functions/test_plugin.fish
    set --local output (fisher update $plugin)
    fisher remove $plugin >/dev/null
    string match --quiet --regex "(^|\\n)Updated 1 plugin/s\$" -- $output
    and echo ok
) = ok

@test fish_plugins (
    string match --regex -- "[^/]+\$" <$__fish_config_dir/fish_plugins | string join " "
) = "fisher fishtape ponyo"

@test "fisher remove" (
    fisher remove tests/ponyo >/dev/null
) "$ponyo" = ""

@test "has state" -n (
    set --names | string match \*fisher\* | string collect
)
