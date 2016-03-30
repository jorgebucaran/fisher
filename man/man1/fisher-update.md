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

Update one or more plugins concurrently. If no arguments are given, update everything, including Fisherman. Use a dash `-` to read from the standard input.

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
