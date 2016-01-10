fisher-tour(7) -- Fisherman Feature Tour
========================================

## DESCRIPTION

Fisherman is a plugin manager and CLI toolkit for Fish to help you build powerful utilities and share your code easily.

Fisherman uses a flat tree structure that adds no cruft to your shell, making it as fast as no Fisherman. The cache mechanism lets you query the index offline and enable or disable plugins as you wish.

Other features include dependency management, great plugin search capabilities and full compatibility with Tackle, Wahoo and oh-my-fish themes and packages.

This document describes Fisherman features and their implementation details. For usage and command help  see `fisher(1)`.

## FLAT TREE

The configuration directory structure is optimized to help your shell start new sessions as quickly as possible, regardless of the numbers of plugins or prompts enabled at any given time. An old saying goes that Fisherman is as fast as no Fisherman.

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

By convention, functions that start with any number of underscores are *intentionally* private, but there is no mechanism that prevents you from calling them at any time once loaded.

With this in mind, it's possible to improve the slow shell start problem using a *flat* tree structure whose path is loaded only once.

The overhead of juggling multiple path hierarchies in a per-plugin basis yields no benefits as everything is shared in the same scope.

Loading a path simply means adding the desired location to the `$fish_function_path` array. See also `functions(1)`.

Here is a snapshot of a typical configuration path with a single plugin and prompt:

    $fisher_config
    |-- cache/
    |-- conf.d/
    |-- |-- my_plugin.config.fish
    |-- functions/
    |   |-- my_plugin.fish
    |   |-- fish_prompt.fish
    |   |-- fish_right_prompt.fish
    |-- completions/
    |   |-- my_plugin.fish
    |-- man/
        |-- man1/
            |-- my_plugin.1

If you are already familiar in the way fish handles your user configuration, you will find the above structure similar to `$XDG_CONFIG_HOME/fish`. See `Initialization Files` in `help fish` to learn more about fish configuration.

`conf.d`, short for configuration directory, is used for initialization files, i.e., files that should run at the start of the shell. Files that follow the naming convention `<name>.config.fish` are added there.

### PLUGINS

Plugins are components that extend and add features to your shell. To see what plugins are available use `fisher search`. You can also type `fisher install` and hit *tab* once to get formatted plugin information. The same works for `fisher update` and `fisher uninstall`.

To learn how to create plugins, see `fisher help plugins`.

You can install a plugin by their name, URL or path to a local project.

If you use a *name*, this must be listed in the index database. See `Index`.

```
fisher install shark
```

You can use an URL too if you have one.

```
fisher install simnalamburt/shellder
```

If the domain or host is not provided, Fisherman will use any value in `$fisher_default_host` to guess the full URL. The default value is `https://github.com`.

In addition, all of the following `owner/repo` variations are accepted:

* owner/repo `>` https://github.com/owner/repo<br>
* *github*/owner/repo `>` https://github.com/owner/repo<br>
* *gh*/owner/repo `>` https://github.com/owner/repo<br>

Shortcuts to other common Git repository hosting services are also available:

* *bb*/owner/repo `>` https://bitbucket.org/owner/repo<br>
* *gl*/owner/repo `>` https://gitlab.com/owner/repo<br>
* *omf*/owner/repo `>` https://github.com/oh-my-fish/repo<br>

Because of Fisherman's flat tree model, there is no technical distinction between plugins or prompts. Installing a prompt is equivalent to switching themes in other systems. The interface is always *install*, *update* or *uninstall*.

Throughout this document and other Fisherman manuals you will find the term prompt when referring to the *concept* of a theme, i.e., a plugin that defines a `fish_prompt` and / or `fish_right_prompt` functions.

### INDEX

You can install, update and uninstall plugins by name, querying the Fisherman index, or by URL using several of the variations described in `Plugins`. The index is a plain text flat database *independent* from Fisherman. You can use a custom index file by setting `$fisher_index` to your own file or URL. Redirection urls are not supported due to security and performance concerns. See `fisher help config`.

A copy of the index is downloaded each time a query happens. This keeps the index up to date and allows you to search the database offline.

The index is a list of records, each consisting of the following fields:

* `name`, `url`, `info`, `author` and one or more `tags`.

Fields are separated by a new line `'\n'`. Tags are separated by one *space*. Here is a sample record:

```
shark
https://github.com/bucaran/shark
Sparklines for your Fish
graph spark data
bucaran
```

To submit a new plugin for registration install the `submit` plugin:

```
fisher install submit
```

For usage see the bundled documentation `fisher help submit`.

You can also submit a new plugin manually and create a pull request.

```
git clone https://github.com/fisherman/fisher-index
cd index
echo "$name\n$URL\n$info\n$author\n$tags\n\n" >> index
git push origin master
open http://github.com
```

Now you can create a new pull request in the upstream repository.

### CACHE

Downloaded plugins are tracked as Git repositories under `$fisher_cache`. See `fisher help config` to find out about other Fisherman configuration variables.

When you install or uninstall a plugin, Fisherman downloads the repository to the cache and copies only the relevant files from the cache to the loaded function and / or completion path. In addition, man pages are added to the corresponding man directory and if a Makefile is detected, the command `make` is run.

The cache also provides a location for a local copy of the Index.

### FISHFILES

Dependency manifest file, or fishfiles for short, let you share plugin configurations across multiple installations, allow plugins to declare dependencies, and prevent information loss in case of system failure. See `fisher help fishfile`.

Here is an example fishfile inside `$fisher_config`:

```
# my plugins
gitio
fishtape

# my links
github/bucaran/shark
```

The fishfile updates as you install / uninstall plugins. See also `fisher help install` or `fisher help uninstall`.

Plugins may list any number of dependencies to other plugins in a fishfile at the root of each project. By default, when Fisherman installs a plugin, it will also fetch and install its dependencies. If a dependency is already installed, it will not be updated as this could potentially break other plugins using an older version. For the same reasons, uninstalling a plugin does not remove its dependencies. See `fisher help update`.


### CONFIGURATION

Fisherman allows a high level of configuration using `$fisher_*` variables. You can customize the home and configuration directories, debug log file, cache location, index source URL, command aliases, etc. See `fisher help config`.

You can also extend Fisherman by adding new commands and ship them as plugins as well. Fisherman automatically adds completions to *commands* based in the function *description* and usage help if provided. See `fisher help help` and `fisher help commands`.

To add completions to standalone utility plugins, use `complete(1)`.

### CLI

If you are already familiar with other UNIX tools, you'll find Fisherman commands behave intuitively.

Most commands read the standard input by default when no options are given and produce easy to parse output, making Fisherman commands ideal for plumbing and building upon each other.

Fisherman also ships with a CLI options parser and a background job wait spinner that you can use to implement your own commands CLI. See `getopts(1)` and `wait(1)`.

## COMPATIBILITY

Fisherman supports oh-my-fish (Wahoo) themes and plugins by default, but some features are turned off due to performance considerations.

oh-my-fish evaluates every *.fish* file inside the root directory of every plugin during initialization. This is necessary in order to register any existing `init` events and invoke them using fish `emit(1)`.

Since it is not possible to determine whether a file defines an initialization event without evaluating its contents first, oh-my-fish sources all `*.fish` files and then emits events for each plugin.

Not all plugins opt in the initialization mechanism, therefore support for this behavior is turned off by default. If you would like Fisherman to behave like oh-my-fish at the start of every session, install the `omf` compatibility plugin.

```
fisher install omf
```

This plugin also adds definitions for some of oh-my-fish Core Library functions.

## SEE ALSO

fisher(1)<br>
fisher help<br>
fisher help config<br>
fisher help plugins<br>
fisher help commands<br>
wait(1)<br>
getopts(1)<br>
