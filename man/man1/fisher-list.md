fisher-list(1) -- List installed plugins
========================================

## SYNOPSIS

fisher list [*file*]<br>
fisher list [--enabled] [--disabled] [--help]<br>

## USAGE

fisher list [*file*]

## DESCRIPTION

The list command displays all the plugins that are currently installed.

```
fisher list
  debug
  fishtape
  spin
> superman
@ wipe
```

The legend consists of:

`>` Indicate the plugin is a prompt<br>
`@` Indicate the plugin is a symbolic link<br>

## OPTIONS

* --enabled:
    List plugins that are enabled.

* --disabled:
    List plugins that are not installed, but available in the cache.

* -h, --help:
    Show usage help.

## SEE ALSO

fisher help search<br>
