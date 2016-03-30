fisher-uninstall(1) -- Uninstall plugins
========================================

## SYNOPSIS

fisher uninstall [*plugins* ...]<br>
fisher uninstall [--force] [--quiet] [--help]<br>

## USAGE

fisher uninstall *url*<br>
fisher uninstall *name*<br>
fisher uninstall *path* <br>
fisher uninstall *owner/repo*<br>

## DESCRIPTION

Uninstall one or more plugins. If no arguments are given, read the standard input.

Uninstall does not remove any copies of the given plugin in $fisher_cache. To erase the copy from the cache, use the --force option.

Uninstall does not remove any dependencies installed with other plugins.

## OPTIONS

* -f, --force:
    Delete copy from cache.

* -q, --quiet:
    Enable quiet mode.

* -h, --help:
    Show usage help.

## EXAMPLES

* Uninstall all plugins flushing the cache.

```fish
fisher list | fisher uninstall --force
```

## SEE ALSO

fisher help install<br>
