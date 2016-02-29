fisher-update(1) -- Update plugins
==================================

## SYNOPSIS

fisher update [*plugins* ...] [--quiet] [--help] <br>

## USAGE

fisher update *url* ...<br>
fisher update *name* ...<br>
fisher update *path*  ...<br>
fisher update *owner/repo* ...<br>

## DESCRIPTION

Update one or more plugins, by name, URL or path. If no arguments are given, update Fisherman to the latest release. If you try to update a plugin that is currently disabled, but exists in the cache, it will be updated and then enabled. Use a dash `-` to read from the standard input.

If a plugin is missing dependencies, they will be installed. If any dependencies are already installed they will not be updated.

## OPTIONS

* -q, --quiet:
    Enable quiet mode.

* -h, --help:
    Show usage help.

## EXAMPLES

* Update Fisherman.

```fish
fisher update
```

* Update all the plugins in the cache.

```fish
fisher list | fisher update -
```

* Update all the plugins in the cache concurrently.

```fish
fisher list --bare | xargs -n1 -P0 fish -c "fisher update -"
```
