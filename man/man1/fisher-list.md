fisher-list(1) -- List installed plugins
========================================

## SYNOPSIS

fisher list [*file*]<br>
fisher list [--bare] [--link] [--enabled] [--disabled] [--help]<br>

## USAGE

fisher list [*file*]

## DESCRIPTION

The list command displays all the plugins you have installed.

```
fisher list
  debug
* fishtape
> shellder
* spin
@ wipe
```

The legend consists of:

`*` Indicate the plugin is currently installed<br>
`>` Indicate the plugin is a prompt<br>
`@` Indicate the plugin is a symbolic link<br>

## OPTIONS

* -b, --bare:
    List plugin without decorators

* -l, --link:
    List plugins that are symbolic links

* --enabled:
    List plugins that are enabled

* --disabled:
    List plugins that are disabled

* -h, --help:
    Show usage help

## SEE ALSO

fisher help search<br>
