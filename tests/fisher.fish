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
) "$ponyo" = "pyon pyon pyon"

@test "fisher remove" (
    fisher remove tests/ponyo >/dev/null
) "$ponyo" = ""

@test "has state" -n (
    set --names | string match \*fisher\* | string collect
)

@test fish_plugins (
    fisher list | string collect
) = (read --null <$__fish_config_dir/fish_plugins | string collect)
