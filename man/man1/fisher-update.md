fisher-update(1) -- Fisherman Update Manager
============================================

## SYNOPSIS

fisher `update` [*name* or *url* ...] <br>
fisher `update` [`--me`] [`--quiet`] [`--help`] <br>

## USAGE

fisher `update` *plugin* ...<br>
fisher `update` *owner/repo* ...<br>

## DESCRIPTION

Update one or *more* plugins by *name*, searching `$fisher_index` or by *url*. If no arguments are given, read the standard input. If you try to update a plugin that is currently disabled, but available in the cache, it will be updated and then enabled.

If a plugin is missing dependencies, they will be installed. If any dependencies are already installed they will not be updated in order to prevent mismatching version issues. See `fisher help fishfile`#{`Plugins`}.

## OPTIONS

* `-m` `--me`:
    Update Fisherman.

* `-q` `--quiet`:
    Enable quiet mode.

* `-h` `--help`:
    Show usage help.

## EXAMPLES

* Update all plugins in the cache.

fisher --cache=base | fisher update

## SEE ALSO

`fisher`(1)<br>
`fisher help fishfile`#{`Plugins`}<br>
`fisher help plugins`<br>
