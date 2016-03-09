fisher-help(1) -- Show help about Fisherman
===========================================

## SYNOPSIS

fisher help [*command*] [--help]<br>

## USAGE

fisher help *command*<br>

## DESCRIPTION

Help displays *command* documentation, usage, guides and tutorials.

Help is based in man(1) pages. To supply help with your own plugin or command, create one or more man.1~7 pages and add them to your project under the corresponding man/man% directory.

```
my_plugin
|-- my_plugin.fish
`-- man
    `-- man1
        `-- my_plugin.1
```

Help for my_plugin is available via man(1). To add documentation to a fisher command, prepend the keyword fisher- to the man file, e.g., fisher-my-command.1. This will teach Fisherman how to access the man page using fisher help my-command.

There are utilities that can help you generate man pages from other text formats, such as Markdown. For example pandoc(1) or ronn(1).

## OPTIONS

* -h, --help:
    Show usage help.

## SEE ALSO

man(1), fisher(1)
