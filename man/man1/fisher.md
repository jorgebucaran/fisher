fisher(1) -- fish shell manager
===============================

## SYNOPSIS

`fisher` *command* [*options*] [`--version`] [`--help`]<br>
`fisher` `--file`=*fishfile*<br>
`fisher` `--validate`=*name* or *url*<br>

## DESCRIPTION

Fisherman is a shell manager for `fish`(1) that lets you share and reuse code, prompts and configurations easily.

The following commands: *install*, *uninstall*, *update*, *search* and *help* are available by default. See `fisher` help *command* for information about each command.

## OPTIONS

* `-f` `--file`=*fishfile*:
    Read *fishfile* and write contents to standard output. If *fishfile* is null or an empty string, your user *fishfile* in `$fisher_config`/fishfile will be used instead. Use a dash `-` to force reading from the standard input. Oh My Fish! bundle files are supported too.

* `-V`, `--validate`=*keyword*:
    Validate a *name* or *url*. If *keyword* resembles a url, the algorithm will attempt to normalize the url by adding / removing missing components. Otherwise, it will assume *keyword* is a potential plugin name and use the following regex `^[a-z]+[._-]?[a-z0-9]+` to validate the string. This method is used internally to validate user input and support url variations such as *owner/repo*, *gh:owner/repo*, *bb:owner/repo*, etc. See `fisher`(7)#{`Plugins`}.

    If *keyword* is null or an empty string, `--validate` reads keyword*s* from the standard input.

* `-v` `--version`:
    Show version information. Fisherman's current version can be found in the VERSION file at the root of the project. The version scheme is based in `Semantic Versioning` and uses Git annotated tags to track releases.

* `-h` `--help`:
    Show usage help.

## CUSTOM COMMANDS

A Fisherman command is a function that you can invoke using `fisher` *command* [*options*]. By convention, any function of the form `fisher_<my_command>` is registered as Fisherman command. You can create plugins that add new commands as well as regular utilities. See `fisher help commands` and `fisher help plugins` for more information.

## EXAMPLES

* Install a plugin.

```
fisher install fishtape
fishtape --help
```

* Install plugins from fishfile or bundle:

```
fisher --file=path/to/shared/fishfile | fisher install
```

* Validate an url.

```
echo a/b | fisher -V
> https://github.com/a/b
```

## AUTHORS

Fisherman was created and it is currently maintained by Jorge Bucaran *j@bucaran.me*.

See AUTHORS file for a more complete list of contributors.

## SEE ALSO

`fisher`(7)<br>
`fisher` help *help*<br>
`fisher` help *update*<br>
`fisher` help *search*<br>
`fisher` help *config*<br>
`fisher` help *install*<br>
`fisher` help *plugins*<br>
`fisher` help *commands*<br>
`fisher` help *fishfile*<br>
`fisher` help *uninstall*<br>
