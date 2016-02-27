fisher-update(1) -- Update Fisherman and Plugins
================================================

## SYNOPSIS

fisher `update` [*plugins* ...] [`--quiet`] [`--help`] <br>

## USAGE

fisher `update` *url* ...<br>
fisher `update` *name* ...<br>
fisher `update` *path*  ...<br>
fisher `update` *owner/repo* ...<br>

## DESCRIPTION

Update one or more plugins, by name, URL or a local path. If no arguments are given, update Fisherman to the latest release. If you try to update a plugin that is currently disabled, but present in the cache, it will be updated and then enabled. Use a dash `-` to read from the standard input.

One exception to the process described above is updating a prompt which is not the current one. In this case the repository is updated, but it will not be activated as that is probably not what the user wants.

If a plugin is missing dependencies, they will be installed. If any dependencies are already installed they will not be updated. See `Plugins` in `fisher help fishfile`.

## OPTIONS

* `-q --quiet`:
    Enable quiet mode.

* `-h --help`:
    Show usage help.

## EXAMPLES

* Update Fisherman

```fish
fisher update
```

* Update all the plugins in the cache *concurrently*.

```fish
fisher --list | cut -c 2- | xargs -n1 -P0 fish -c 'fisher update'
```

## SEE ALSO

`fisher`(1)<br>
`fisher help plugins`<br>
