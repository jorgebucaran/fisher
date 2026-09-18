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

@test fish_plugins (
    string match --regex -- "[^/]+\$" <$__fish_config_dir/fish_plugins | string join " "
) = "fisher fishtape ponyo"

@test "fisher remove" (
    fisher remove tests/ponyo >/dev/null
) "$ponyo" = ""

@test "has state" -n (
    set --names | string match \*fisher\* | string collect
)

@test "hooks can call fisher during update" (
    set --local hook_plugin (command mktemp -d)

    command mkdir -p $hook_plugin/conf.d
    echo "function hookme_update --on-event hookme_update
        set --global hookme (fisher --version)
    end" >$hook_plugin/conf.d/hookme.fish

    fisher install $hook_plugin >/dev/null
    set --global hookme never_ran
    # hook_plugin first, so its hook fires before fisher's turn to be reinstalled
    fisher update $hook_plugin $PWD >/dev/null
    fisher remove $hook_plugin >/dev/null
    command rm -rf $hook_plugin

    string replace --regex -- "^fisher, version .+" ok "$hookme"
    set --erase hookme
) = ok

@test "update to a plugin with no files" (
    set --local bare_plugin (command mktemp -d)

    command mkdir -p $bare_plugin/functions
    echo "function bare; end" >$bare_plugin/functions/bare.fish

    fisher install $bare_plugin >/dev/null
    command rm -rf $bare_plugin/functions
    fisher update $bare_plugin >/dev/null 2>/dev/null

    set --query _fisher_(string escape --style=var -- (realpath $bare_plugin))_files
    and echo stale
    or echo clean

    fisher remove $bare_plugin >/dev/null
    command rm -rf $bare_plugin
) = clean
