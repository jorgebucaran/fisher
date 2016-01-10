fisher(1) -- Fish Plugin Manager
================================

## SYNOPSIS

`fisher` *command* [*options*] [`--version`] [`--help`]<br>
`fisher` `--list`<br>
`fisher` `--alias`[=*command*=[*alias*[,...]]]<br>
`fisher` `--file`=*fishfile*<br>

## DESCRIPTION

Fisherman is a plugin manager for `fish(1)` that lets you share and reuse code, prompts and configurations easily.

The following commands are available: *install*, *uninstall*, *update*, *search* and *help*. See `fisher` help *command* for information about each command.

## OPTIONS

*  `--list`:
    List plugins in the `$fisher_cache`. Includes plugins installed using a custom URL.

* `-a --alias[=command=[alias[,...]]]`:
    Define one or more comma-separated *alias* for *command* using `$fisher_alias`. If no value is given, lists all existing aliases.

* `-f --file=fishfile`:
    Read *fishfile* and display its contents. If *fishfile* is null or an empty string, your user *fishfile* in `$fisher_config/fishfile` will be used instead. Use a dash `-` to force reading from the standard input. oh-my-fish bundle files are supported as well.

* `-v --version`:
    Show version information. Fisherman's current version can be found in the VERSION file at the root of the project. The version scheme is based in `Semantic Versioning` and uses Git annotated tags to track releases.

* `-h --help`:
    Show usage help.

## CUSTOM COMMANDS

A Fisherman command is a function that you can invoke using the `fisher` utility. By convention, any function like `fisher_<my_command>` is registered as a Fisherman command. You can create plugins that add new commands this way. See `fisher help commands` and `fisher help plugins` for more information.

## EXAMPLES

* Install plugins.

```
fisher install fishtape shark
```

* Install plugins from a *fishfile* or bundle:

```
fisher --file=path/to/shared/fishfile | fisher install
```

* Define a few aliases:

```
fisher -a uninstall=rm,u,del
```

## AUTHORS

Fisherman was created by Jorge Bucaran *j@bucaran.me*.

See AUTHORS file for a more complete list of contributors.

## SEE ALSO

fisher(7)<br>
fisher help<br>
fisher update<br>
fisher search<br>
fisher config<br>
fisher install<br>
fisher plugins<br>
fisher commands<br>
fisher fishfile<br>
fisher uninstall<br>
