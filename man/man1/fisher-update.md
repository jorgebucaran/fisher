fisher-update(1) -- Fisherman Update Manager
============================================

## SYNOPSIS

fisher `update` [*name*, *url* or *path* ...] <br>
fisher `update` [`--quiet`] [`--help`] <br>

## USAGE

fisher `update` *plugin* ...<br>
fisher `update` *owner/repo* ...<br>
fisher `update` *path*  ...<br>

## DESCRIPTION

Update one or *more* plugins by *name*, searching `$fisher_index` or by *url*. If no arguments are given, update Fisherman by default. If you try to update a plugin that is currently disabled, but downloaded to the cache, it will be updated and then enabled. Use a dash `-` to read from the standard input.

If a plugin is missing dependencies, they will be installed. If any dependencies are already installed they will not be updated. See `fisher help fishfile`#{`Plugins`}.

## OPTIONS

* `-q` `--quiet`:
    Enable quiet mode.

* `-h` `--help`:
    Show usage help.

## EXAMPLES

* Update all plugins in the cache.

fisher --list | fisher update -

## SEE ALSO

`fisher`(1)<br>
`fisher help fishfile`#{`Plugins`}<br>
`fisher help plugins`<br>
