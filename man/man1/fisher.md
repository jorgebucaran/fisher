fisher(1) -- Fish Plugin Manager
================================

## SYNOPSIS

`fisher` *command* [*options*] [`--version`] [`--help`]<br>
`fisher` `--list=cache|enabled|disabled`<br>
`fisher` `--file`=*fishfile*<br>

## DESCRIPTION

Fisherman is a plugin manager and CLI toolkit for `fish(1)` to help you build powerful utilities and share your code easily.

The following commands are available out of the box: *install*, *uninstall*, *update*, *search* and *help*. See `fisher help <command>` for information about each command.

## OPTIONS

*  `--list=cache|enabled|disabled`:
    List plugins according to the given category.

* `-f --file=fishfile`:
    Read *fishfile* and display its contents. If *fishfile* is null or an empty string, your user *fishfile* in `$fisher_config/fishfile` will be shown instead. Use a dash `-` to read from the standard input. Other formats such as the oh-my-fish bundle files are supported as well.

* `-v --version`:
    Show version information. Fisherman's current version can be found in the VERSION file at the root of the project. The version scheme is based in `Semantic Versioning` and uses Git annotated tags to track releases.

* `-h --help`:
    Show usage help.

## CUSTOM COMMANDS

A Fisherman command is a function that you invoke using the `fisher` CLI utility. By convention, any function like `fisher_<my_command>` is recognized as a Fisherman command. You can create plugins that add new commands this way. See `fisher help commands` and `fisher help plugins` for more information.

## EXAMPLES

* Install plugins.

```
fisher install fishtape shark
```

* Install plugins from a *fishfile* or bundle:

```
fisher --file=path/to/bundle | fisher install
```

## AUTHORS

Fisherman was created by Jorge Bucaran *j@bucaran.me*.

See AUTHORS file for the complete list of contributors.

## SEE ALSO

fisher help tour<br>
fisher help help<br>
fisher help update<br>
fisher help search<br>
fisher help config<br>
fisher help install<br>
fisher help plugins<br>
fisher help commands<br>
fisher help fishfile<br>
fisher help uninstall<br>
