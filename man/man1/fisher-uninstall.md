fisher-uninstall(1) -- Uninstall Plugins
==================================================

## SYNOPSIS

fisher `uninstall` [*plugins* ...] <br>
fisher `uninstall` [`--force`] [`--quiet`] [`--help`] <br>

## USAGE

fisher `uninstall` *plugin*<br>
fisher `uninstall` *owner/repo*<br>
fisher `uninstall` *path*<br>

## DESCRIPTION

Uninstall one or more plugins, by name, URL or local path. If no arguments are given, read the standard input. This process is the inverse of Install. See `fisher help install`.

Uninstall does not remove any copies of the given plugin in `$fisher_cache`. To erase the copy from the cache, use the `--force` option.

Uninstall does not remove any dependencies installed with other plugins. This behavior prevents breaking plugins that share the same dependency. See `Flat Tree` in `fisher(7)`.

## OPTIONS

* `-f --force`:
    Delete copy from cache.

* `-q --quiet`:
    Enable quiet mode.

* `-h --help`:
    Show usage help.

## EXAMPLES

* Uninstall all plugins and flush the cache.

```
fisher --list | fisher uninstall --force
```

## SEE ALSO

fisher(1)<br>
fisher help plugins<br>
