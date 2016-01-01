fisher-uninstall(1) -- Disable / Uninstall Plugins
==================================================

## SYNOPSIS

fisher `uninstall` [*name* or *url* ...] <br>
fisher `uninstall` [`--all`] [`--force`] [`--quiet`] [`--help`] <br>

## USAGE

fisher `uninstall` *plugin* ...<br>
fisher `uninstall` *owner/repo* ...<br>

## DESCRIPTION

Uninstall one or *more* plugins by *name*, searching `$fisher_index` or by *url*. If no arguments are given, read the standard input. This process is the inverse of Install. See `fisher help install`.

Uninstall does not remove any copies of the given plugin in `$fisher_cache`. To erase the copy from the cache, use the `--force` option.

Uninstall does not remove dependencies installed along with other plugins. This behavior prevents breaking plugins that share the same dependency. See `fisher`(7){`Flat Tree`}.

## OPTIONS

* `-a` `--all`:
    Uninstall all plugins.

* `-f` `--force`:
    Delete copy from cache.

* `-q` `--quiet`:
    Enable quiet mode.

* `-h` `--help`:
    Show usage help.


## EXAMPLES

Uninstall all installed plugins and flushing the cache as well.

```
fisher uninstall --all --force
```

## SEE ALSO

`fisher`(1)<br>
`fisher help plugins`<br>
