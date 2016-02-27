fisher-tour(7) -- Fisherman Tour
================================

## DESCRIPTION

Fisherman is a blazing fast, modern plugin manager for `fish`(1).

Fisherman runs virtually no initialization code, making it **as fast as no Fisherman**. The cache mechanism lets you query the index offline and enable or disable plugins as you wish.

Other features include dependency management, excellent test coverage, plugin search capabilities and full compatibility with Tackle, Oh My Fish! and Wahoo themes and plugins.

This document describes Fisherman features and their implementation details. For usage and command help  see `fisher`(1).

## FLAT TREE

The configuration directory structure is optimized to help your shell start new sessions as quickly as possible, regardless of the numbers of plugins or prompts enabled at any given time.

To explain how this is possible, we need to make a digression and discuss function scope first. In fish, all functions share the same scope and you can use only one name per function.

In the following example:

```
function foo
    echo $_
    function bar
    end
end

function bar
    echo $_
end
```

*foo* and *bar* are available immediately at the command line prompt and both print their names. But there is a catch, calling *foo* at least once will create a new *bar* function, effectively erasing the previous *bar* definition. Subsequent calls to *bar* will print nothing.

By convention, functions that start with any number of underscores are *intentionally* private, but there is no mechanism that prevents you from calling them once they are loaded.

With this in mind, it's possible to improve the slow shell start problem using a *flat* tree structure whose path is loaded only once.

The overhead of juggling multiple path hierarchies in a per-plugin basis yields no benefits as everything is shared inside the same scope.

Loading a path simply means adding the desired location to the `$fish_function_path` array. See also `functions`(1).

Here is a snapshot of an example Fisherman configuration path with a single plugin and prompt:

```
$fisher_config
|-- cache/
|-- conf.d/
|   `-- <my_plugin>.config.fish
|-- fishfile
|-- functions/
|   |-- <my_plugin>.fish
|   |-- fish_prompt.fish
|   `-- fish_right_prompt.fish
|-- completions/
|   `-- <my_plugin>.fish
`-- man/
    `-- man1/
        `-- <my_plugin>.1
```

If you are already familiar in the way Fish handles your user configuration, you will find the above structure similar to `$XDG_CONFIG_HOME/fish`. See `Initialization Files` in `help fish` to learn more about fish configuration.

`conf.d`, short for configuration directory, is used for initialization files, i.e., files that should run at the start of the shell. Files that follow the naming convention `<my_plugin>.config.fish` are added there. If a file does not follow the `<my_plugin>.config.fish` convention, `<my_plugin>` will be added during the installation process.

### PLUGINS

Plugins are components that extend and add features to your shell. To see what plugins are available use `fisher search`. You can also type `fisher install` and hit *tab* once to get formatted plugin information. The same works for `fisher update` and `fisher uninstall`.

To learn how to create plugins, see `fisher help plugins`.

You can install a plugin by their name, URL or by indicating the path to a local plugin project.

In order to install a plugin by *name*, it must be already published in the index database. See `Index`.

```
fisher install shark
```

You can use an URL too if you have one.

```
fisher install simnalamburt/shellder
```

If the domain or host is not provided, Fisherman will use `https://github.com` by default.

In addition, all of the following `owner/repo` variations are accepted:

* owner/repo `>` https://github.com/owner/repo<br>
* *github*/owner/repo `>` https://github.com/owner/repo<br>
* *gh*/owner/repo `>` https://github.com/owner/repo<br>

Shortcuts to other common Git repository hosting services are also available:

* *bb*/owner/repo `>` https://bitbucket.org/owner/repo<br>
* *gl*/owner/repo `>` https://gitlab.com/owner/repo<br>
* *omf*/owner/repo `>` https://github.com/oh-my-fish/repo<br>

Because of Fisherman's flat tree model, there is no technical distinction between plugins or prompts. Installing a prompt is equivalent to switching themes in other systems. The interface is always *install*, *update* or *uninstall*.

Throughout this document and other Fisherman manuals you will find the term prompt when referring to the *concept* of a theme, i.e., a plugin that defines a `fish_prompt` / `fish_right_prompt` function/s.

### INDEX

You can install, update and uninstall plugins by their name, querying the Fisherman index. The index is a plain text flat database independently managed. You can use a custom index file by setting `$fisher_index` to your own file or URL. Redirection URLs are currently not supported due to security and performance concerns. See `fisher help config`.

A copy of the index is downloaded each time a search query takes place, `$fisher_update_interval` seconds since the last update. `$fisher_update_interval` is 10 seconds by default if not set. This helps keeping the index up to date and allows you to search the database offline.

The index itself is a list of records, each consisting of the following fields:

* `name`, `url`, `info`, one or more `tags` and `author`.

Fields are separated by a new line `'\n'`. Tags are separated by one *space*. Here is a sample record:

```
shark
https://github.com/bucaran/shark
Fantastic Sparkline Generator
chart tool report sparkline graph
bucaran
```

To submit a new plugin for registration install the `submit` plugin:

```
fisher install submit
```

For usage see the bundled documentation `fisher help submit`.

You can also submit a new plugin manually and create a pull request in the index repository (github.com/fisherman/fisher-index):

```
git clone https://github.com/fisherman/fisher-index
cd index
echo "$name\n$URL\n$info\n$author\n$tags\n\n" >> index
git push origin master
open http://github.com
```

### CACHE

Downloaded plugins are stored as Git repositories under `$fisher_cache`. See `fisher help config` to find out about other Fisherman configuration variables.

When you install or uninstall a plugin, Fisherman downloads the repository to the cache and copies only the relevant files from the cache to the loaded function and / or completion path. In this sense, this location works also like an intermediate `stage`. In addition, manual pages are added to the corresponding man directory and if a Makefile is also detected, the command `make` is run.

### FISHFILES

Fishfiles let you share plugin configurations across multiple installations, let plugins declare dependencies and teach Fisherman what plugins are currently enabled / disabled when using `fisher --list`.

Your fishfile is stored in `$fisher_config/fishfile` by default, but you can customize its location setting `$fisher_file` in your user fish configuration file.

Here is an example fishfile inside `$fisher_config`:

```
# Ahoy! This is my Fishfile
gitio
fishtape
shark
get
```

The fishfile updates as you install / uninstall plugins. See also `fisher help install` or `fisher help uninstall`.


### CONFIGURATION

Fisherman allows a high level of configuration using `$fisher_*` variables. You can customize the home and configuration directories, cache and fishfile location, index source URL, command aliases, etc. See `fisher help config`.

You can also extend Fisherman by adding new commands and ship them as plugins. Fisherman automatically adds completions to *commands* based in the function *description* and usage help if provided. See `fisher help help` and `fisher help commands`.

To add completions to standalone utility plugins, use `complete`(1).

### CLI

If you are already familiar with other UNIX tools, you'll find Fisherman commands behave intuitively.

Most commands read the standard input by default when no options are given and produce easy to parse output, making Fisherman commands ideal for plumbing and building upon each other.

Fisherman also ships with a CLI options parser and a job spinner you can use to implement your own CLIs. See `getopts`(1) and `spin`(1).

## COMPATIBILITY

Fisherman supports Oh My Fish! themes and plugins, but some features are turned off by default for performance reasons.

Oh My Fish! evaluates every *.fish* file inside the root directory for every plugin installed during shell start. This is necessary in order to load any existing `init` event functions and immediately invoke them using fish `emit`(1).

Since it is not possible to determine whether a file defines an initialization event without evaluating its contents first, Oh My Fish! sources all `*.fish` files and then emits events for each plugin.

Not all plugins opt in the initialization mechanism, therefore support for this behavior is turned off by default. If you would like Fisherman to behave like Oh My Fish! at the start of the shell session, install the `legacy` compatibility plugin.

```
fisher install legacy
```

This plugin also adds definitions for some of Oh My Fish! Core Library functions.

## SEE ALSO

`fisher`(1), `spin`(1), `getopts`(1)<br>
`fisher help`<br>
`fisher help config`<br>
`fisher help plugins`<br>
`fisher help commands`<br>
