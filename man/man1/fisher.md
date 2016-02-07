fisher(1) -- Fish Plugin Manager
================================

## SYNOPSIS

`fisher` *command* [*options*] [`--version`] [`--help`]<br>
`fisher` `--list=cache|enabled|disabled`<br>
`fisher` `--file`=*fishfile*<br>

## DESCRIPTION

Fisherman is a blazing fast, modern plugin manager for `fish(1)`.

The following commands are available: *install*, *uninstall*, *update*, *search* and *help*. See `fisher help <command>` for information about each command.

## OPTIONS

*  `--list[=bare|url|all|enabled|disabled|theme|file]`:
    List local plugins according to a given option. Plugins are prepended with a legend character to indicate their kind. `*` for enabled plugins, `>` for the currently enabled prompt and `|` for symbolic links. To list plugins without the legend use `--list=bare`. Use a dash `-` to read from the standard input.

* `-v --version`:
    Show version information. Fisherman's current version can be found in the VERSION file at the root of the project. The version scheme is based in `Semantic Versioning` and uses Git annotated tags to track each release.

* `-h --help`:
    Show usage help.

## CUSTOM COMMANDS

A Fisherman command is a regular function that can be invoked using the `fisher` command. By convention, any function like `fisher_<my_command>` is recognized as a Fisherman command. You can create plugins that add new commands this way. See `fisher help commands` and `fisher help plugins` for more information.

## EXAMPLES

* Install plugins.

```fish
fisher install fishtape shark get
```

* Install plugins from a *fishfile* or bundle.

```fish
fisher --list=path/to/bundle | fisher install
```

* Install a plugin if inside a plugin project.

```fish
fisher install .
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
