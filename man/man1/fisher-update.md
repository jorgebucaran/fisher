fisher-update(1) -- Update Fisherman and Plugins
================================================

## SYNOPSIS

fisher `update` [*plugins* ...] <br>
fisher `update` [`--quiet`] [`--help`] <br>

## USAGE

fisher `update` *plugin* ...<br>
fisher `update` *owner/repo* ...<br>
fisher `update` *path*  ...<br>

## DESCRIPTION

Update one or more plugins, by name, URL or local path. If no arguments are given, update Fisherman itself. If you try to update a plugin that is currently disabled, but in the cache, it will be updated and then enabled. Use a dash `-` to read from the standard input.

If a plugin is missing dependencies, they will be installed. If any dependencies are already installed they will not be updated. See `Plugins` in `fisher help fishfile`.

## OPTIONS

* `-q --quiet`:
    Enable quiet mode.

* `-h --help`:
    Show usage help.

## EXAMPLES

* Update Fisherman

```
fisher update
```

* Update all plugins in the cache.

```
fisher --list | fisher update -
```

## SEE ALSO

fisher(1)<br>
fisher help plugins<br>
