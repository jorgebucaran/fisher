fisher(1) -- Fish plugin manager
================================

## SYNOPSIS

fisher *command* [*arguments*] [--version] [--help]<br>

## DESCRIPTION

Fisherman is a plugin manager for fish.

The Fisherman CLI consists of the following commands: *install*, *update*, *uninstall*, *list*, *search* and *help*.

## USAGE

Run a command.

```
fisher <command> [<arguments>]
```

Get help about a command.

```
fisher help <command>
```

Fisherman knows the following aliases by default: *i* for install, *u* for update, *l* for list, *s* for search and *h* for help.

## OPTIONS

* -v, --version:
    Show version information. Fisherman follows Semantic Versioning and uses Git annotated tags to track releases.

* -h, --help:
    Show usage help.

## EXAMPLES

* Install plugins.

```fish
fisher install fishtape shark get
```

* Install a plugin as a symbolic link.

```fish
fisher install ./path/to/plugin
```

* Update Fisherman to the latest version.

```fish
fisher update
```

* Search the Fisherman index.

```fish
fisher search
```

* Show all the documentation.

```fish
fisher help --all
```

## CONCEPTS

### FLAT TREE

Fisherman merges the directory trees of all the plugins it installs into a single flat tree. Since the flat tree is loaded only once at the start of the shell, Fisherman performs equally well, regardless of the number of plugins installed.

The following illustrates an example Fisherman configuration path with a single plugin and prompt.

```
$fisher_config
|-- cache/
|-- conf.d/
|   `-- my_plugin.config.fish
|-- fishfile
|-- functions/
|   |-- my_plugin.fish
|   |-- fish_prompt.fish
|   `-- fish_right_prompt.fish
|-- completions/
|   `-- my_plugin.fish
`-- man/
    `-- man1/
        `-- my_plugin.1
```

### PLUGINS

To install plugins, type fisher install and press *tab* once to list all the available plugins. Similarly, use fisher update / uninstall and press *tab* to see what plugins you can update or uninstall.

To search plugins use fisher search *name*. You can by a specific field using fisher search --*field*=*match*.

```fish
fisher search --tag={*keywords*}
```

or

```fish
fisher search --name=*name*
```

See fisher help search for advanced options.

To learn how to create plugins enter fisher help tutorial.

### INDEX

The index is a plain text database that lists Fisherman official plugins.

The index is a list of records, each consisting of the following fields: *name*, *url*, *info*, one or more *tags* and *author*.

Fields are separated by a new line `\n`. Tags are separated by one *space*.

```
z
https://github.com/fishery/fish-z
Pure-fish z directory jumping
z search cd jump
jethrokuan
```

If you have a plugin you would like to submit to the index, use the submit plugin.

```
fisher install submit
fisher submit my_plugin
```

Otherwise, submit the plugin manually by creating a pull request in the index repository *https://github.com/fisherman/fisher-index*.

```
git clone https://github.com/fisherman/fisher-index
cd index
echo "$name\n$url\n$info\n$tags\n$author\n\n" >> index
git push origin master
```

### FISHFILE

Fisherman keeps track of a special file known as *fishfile* to know what plugins are currently enabled.

```
# My Fishfile
gitio
fishtape
shark
get
shellder
```

This file is automatically updated as you install and uninstall plugins.

### VARIABLES

* $fisher_home:
    The home directory. If you installed Fisherman using the recommended method `curl -sL install.fisherman.sh | fish`, the location ought to be *XDG_DATA_HOME/fisherman*. If you clone Fisherman and run make yourself, the current working directory is used by default.

* $fisher_config:
    The configuration directory. This is default location of the *fishfile*, *key_bindings.fish*, *cache*, *functions*, *completions* and *conf.d* directories. The default location is *XDG_CONFIG_HOME/fisherman*.

* $fisher_file:
    See FISHFILE above.

* $fisher_cache:
    The cache directory. Plugins are downloaded to this location.

* $fisher_alias *command*=*alias*[,*alias2*] ...:
    Use this variable to customize Fisherman command aliases.

## AUTHORS

Fisherman was created by Jorge Bucaran :: @bucaran :: *j@bucaran.me*.

See THANKS.md file for a complete list of contributors.

## SEE ALSO

fisher help tutorial<br>
