fisher-help(1) -- Show Help
===========================

## SYNOPSIS

fisher `help` [*keyword*] [`--all`] [`--guides`] [`--usage`[=*command*]] [`--help`] <br>

## USAGE

fisher `help` *command*<br>
fisher `help` *guide*<br>
fisher `help` `--usage`=[*command*]<br>

## DESCRIPTION

Help displays *command* documentation, usage, guides and tutorials.

Help is based in `man(1)` pages. To supply help with your own plugin or command, create one or more man.1~7 pages and add them to your project under the corresponding man/man% directory.

```
my_plugin
|-- my_plugin.fish
|-- man
    |-- man1
        |-- my_plugin.1
```

Help for my_plugin is now available via `man(1)`. To add documentation to a `fisher` command, prepend the keyword `fisher-` to the man file, e.g., `fisher-my-command.1`. This will teach Fisherman how to access the man page using `fisher help my-command`.

There are utilities that can help you generate man pages from other text formats, such as Markdown. One example is `ronn(1)`. For an example without using external utilities, see *Example* in `fisher help plugins`.

## OPTIONS

* `-a --all`:
    List all available commands and guides.

* `-g --guides[=*bare*]`:
    List guides / tutorials. Use *bare* to generate easy to parse output.

* `--commands[=*bare*]`:
    List commands. This is the default behavior of `fisher help`. Use *bare* to generate easy to parse output.

* `-u --usage[=*command*]`:
    Display usage help for *command*. To teach Fisherman how to display help for your command, *command* must implement a `-h` flag.

* `-h --help`:
    Show usage help.

## EXAMPLES

* Show all the available documentation.

```
fisher help -a
```

* Show documentation about help.

```
fisher help help
```

* Show usage help for all Fisherman commands.

```
fisher help --commands=bare | fisher help --usage
```

## SEE ALSO

man(1)<br>
fisher(1)<br>
