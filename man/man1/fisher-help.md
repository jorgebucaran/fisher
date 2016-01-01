fisher-help(1) -- Display Help Information
==========================================

## SYNOPSIS

fisher `help` [*keyword*] [`--all`] [`--guides`] [`--usage`[=*command*]] [`--help`] <br>

## USAGE

fisher `help` *command*<br>
fisher `help` *concept*<br>
fisher `help` `--usage`=[*command*]

## DESCRIPTION

Help displays *command* documentation, usage, guides and tutorials.

Help is based in `man`(1) pages. To supply help with your own plugin or command, create one or more man.`1~7` pages and add them to your project under the corresponding `man/man%` directory.

```
my_plugin
|-- my_plugin.fish
|-- man
    |-- man1
        |-- my_plugin.1
```

This will allow you to invoke `man` my_plugin. To add documentation to a command, prepend the keyword `fisher-` to the man file, e.g., `fisher-`my-command.1. This will allow you to access the man page via `fisher help my-command`.

There are utilities that can help you generate man pages from other text formats, such as Markdown. One example is `ronn`(1). For a standalone example see `fisher help plugins`#{`Example`}.

## OPTIONS

* `--commands`[=*bare*]:
    List commands. This is the default behavior of `fisher help`. Use *bare* for easy to parse output.

* `-a` `--all`:
    List commands and guides. Display all the available documentation.

* `-g` `--guides`[=*bare*]:
    List guides / tutorials. Use *bare* for easy to parse output.

* `-u` `--usage`[=*command*]:
    Display usage help for *command*. To supply usage help with a command, *command* must accept a `--help` option.

* `-h` `--help`:
    Show usage help.

## EXAMPLES

Display usage help for all Fisherman commands.

```
fisher help --commands=bare | fisher help --usage
```

## SEE ALSO

`fisher`(1)<br>
`fisher help plugins`#{`Example`}<br>
