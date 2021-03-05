# Fisher

> A plugin manager for [Fish](https://fishshell.com)—the friendly interactive shell.

Manage functions, completions, bindings, and snippets from the command line. Extend your shell capabilities, change the look of your prompt and create repeatable configurations across different systems effortlessly.

- 100% _pure_-Fish—easy to contribute to or modify.
- Blazing fast concurrent plugin downloads.
- Zero configuration out of the box.
- Oh My Fish! plugin support.

> #### 💁 [Looking for plugins?](https://git.io/awesome.fish)

## Installation

```console
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
```

> #### ⚠️ [Fish ≥ 3.0 required](https://fishshell.com/docs/current/relnotes.html#fish-3-0-0-released-december-28-2018)

> #### 👋 [Upgrading from Fisher 3.x or 2.x?](https://github.com/jorgebucaran/fisher/issues/652)

## Quickstart

You can install, update, and remove plugins interactively with Fisher, taking advantage of Fish [tab completion](https://fishshell.com/docs/current/index.html#completion) and rich syntax highlighting.

### Installing plugins

Install plugins using the `install` command followed by the path to the repository on GitHub.

```console
fisher install ilancosman/tide
```

To get a specific version of a plugin add an `@` symbol after the plugin name followed by a tag, branch, or [commit](https://git-scm.com/docs/gitglossary#Documentation/gitglossary.txt-aiddefcommit-ishacommit-ishalsocommittish).

```console
fisher install jorgebucaran/nvm.fish@2.1.0
```

You can install plugins from a local directory too.

```console
fisher install ~/path/to/plugin
```

> Fisher expands plugins into your Fish configuration directory by default, overwriting existing files. If you wish to change this behavior, set `$fisher_path` to your preferred location and put it in your function path ([#640](https://github.com/jorgebucaran/fisher/issues/640)).

### Listing plugins

List all the plugins that are currently installed using the `list` command.

```console
$ fisher list
jorgebucaran/fisher
ilancosman/tide
jorgebucaran/nvm.fish@2.1.0
/home/jb/path/to/plugin
```

The `list` command also accepts a regular expression to filter the output.

```console
$ fisher list \^/
/home/jb/path/to/plugin
```

### Updating plugins

The `update` command updates one or more plugins to their latest version.

```console
fisher update jorgebucaran/fisher
```

> Use just `fisher update` to update everything.

### Removing plugins

Remove installed plugins using the `remove` command.

```console
fisher remove jorgebucaran/nvm.fish@2.1.0
```

You may want to remove everything, including Fisher.

```console
fisher list | fisher remove
```

## Using your `fish_plugins` file

Whenever you install or remove a plugin from the command line, Fisher will write down all the installed plugins plugins to `$__fish_config_dir/fish_plugins`. Adding this file to your dotfiles or version control is the easiest way to share your configuration across different systems.

You can also edit this file and run `fisher update` to commit changes. Here's an example:

```console
nano $__fish_config_dir/fish_plugins
```

```diff
jorgebucaran/fisher
ilancosman/tide
jorgebucaran/nvm.fish@2.1.0
+ PatrickF1/fzf.fish
- /home/jb/path/to/plugin
```

```console
fisher update
```

That will install **PatrickF1**/**fzf.fish**, remove /**home**/**jb**/**path**/**to**/**plugin**, and update everything else.

## Creating a plugin

A plugin can be any number of files in a `functions`, `conf.d`, and `completions` directory. Most plugins consist of a single function, or [configuration snippet](https://fishshell.com/docs/current/#initialization-files). This is what a typical plugin looks like.

<pre>
<b>ponyo</b>
├── <b>completions</b>
│   └── ponyo.fish
├── <b>conf.d</b>
│   └── ponyo.fish
└── <b>functions</b>
    └── ponyo.fish
</pre>

Non `.fish` files as well as directories inside those locations will be copied to `$fisher_path` under `functions`, `conf.d`, or `completions` respectively.

### Event system

Plugins are notified as they are being installed, updated, or removed via Fish [events](https://fishshell.com/docs/current/cmds/emit.html).

> `--on-event` functions must already be loaded when their event is emitted. Thus, you should put your event handlers in the `conf.d` directory.

```fish
# Defined in ponyo/conf.d/ponyo.fish

function _ponyo_install --on-event ponyo_install
    # Set universal variables, create bindings, and other initialization logic.
end

function _ponyo_update --on-event ponyo_update
    # Migrate resources, print warnings, and other update logic.
end

function _ponyo_uninstall --on-event ponyo_uninstall
    # Erase "private" functions, variables, bindings, and other uninstall logic.
end
```

## License

[MIT](LICENSE.md)
