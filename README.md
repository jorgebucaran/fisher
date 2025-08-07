# Fisher

> A plugin manager for [Fish](https://fishshell.com)—your friendly interactive shell. [Snag fresh plugins!](https://github.com/jorgebucaran/awsm.fish#readme)

Take control of functions, completions, bindings, and snippets from the command line. Unleash your shell's true potential, perfect your prompt, and craft repeatable configurations across different systems effortlessly. Fisher's zero impact on shell startup keeps your shell zippy and responsive. No gimmicks, just smooth sailing!

- Fisher is 100% pure-Fish, making it easy to contribute or modify
- Scorching fast concurrent plugin downloads that'll make you question reality
- Zero configuration needed—we're not kidding!
- Oh My Fish! plugins supported too

> #### ☝️ [Upgrading from Fisher `3.x` or older? Strap in and read this!](https://github.com/jorgebucaran/fisher/issues/652)

## Installation

```console
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
```

## Quickstart

Fisher lets you install, update, and remove plugins like a boss. Revel in Fish's [tab completion](https://fishshell.com/docs/current/index.html#completion) and rich syntax highlighting while you're at it.

### Installing plugins

To install plugins, use the `install` command and point it to the GitHub repository.

```console
fisher install jorgebucaran/nvm.fish
```

> Wanna install from GitLab? No problemo—just prepend `gitlab.com/` to the plugin path.

You can also snag a specific version of a plugin by adding an `@` symbol after the plugin name, followed by a tag, branch, or [commit](https://git-scm.com/docs/gitglossary#Documentation/gitglossary.txt-aiddefcommit-ishacommit-ishalsocommittish).

```console
fisher install IlanCosman/tide@v6
```

And hey, you can install plugins from a local directory too!

```console
fisher install ~/path/to/plugin
```

> Heads up! Fisher expands plugins into your Fish configuration directory by default, overwriting existing files. If that's not your jam, set `$fisher_path` to your preferred location and put it in your function path ([#640](https://github.com/jorgebucaran/fisher/issues/640)).

### Listing plugins

Use the `list` command to see all your shiny installed plugins.

```console
$ fisher list
jorgebucaran/fisher
ilancosman/tide@v5
jorgebucaran/nvm.fish
/home/jb/path/to/plugin
```

The `list` command also plays nice with regular expressions for filtering the output.

```console
$ fisher list \^/
/home/jb/path/to/plugin
```

### Updating plugins

`update` command to the rescue! It updates one or more plugins to their latest and greatest version.

```console
fisher update jorgebucaran/fisher
```

> Just type `fisher update` to update everything in one fell swoop.

### Removing plugins

Say goodbye to installed plugins with the `remove` command.

```console
fisher remove jorgebucaran/nvm.fish
```

Feeling destructive? Wipe out everything, including Fisher itself.

```console
fisher list | fisher remove
```

## Using your `fish_plugins` file

Whenever you install or remove a plugin from the command line, Fisher jots down all the installed plugins in `$__fish_config_dir/fish_plugins`. Add this file to your dotfiles or version control to easily share your configuration across different systems.

You can also edit this file and run `fisher update` to commit changes like a pro:

```console
$EDITOR $__fish_config_dir/fish_plugins
```

```diff
jorgebucaran/fisher
ilancosman/tide@v5
jorgebucaran/nvm.fish
+ PatrickF1/fzf.fish
- /home/jb/path/to/plugin
```

```console
fisher update
```

This will install **PatrickF1**/**fzf.fish**, remove /**home**/**jb**/**path**/**to**/**plugin**, and update everything else.

## Creating a plugin

Plugins can include any number of files in `functions`, `conf.d`, and `completions` directories. Most plugins are just a single function or a [configuration snippet](https://fishshell.com/docs/current/index.html#configuration). Behold the anatomy of a typical plugin:

<pre>
<b>flipper</b>
├── <b>completions</b>
│   └── flipper.fish
├── <b>conf.d</b>
│   └── flipper.fish
└── <b>functions</b>
    └── flipper.fish
</pre>

Non `.fish` files and directories inside these locations will be copied to `$fisher_path` under `functions`, `conf.d`, or `completions` respectively.

### Event system

Fish [events](https://fishshell.com/docs/current/cmds/emit.html) notify plugins when they're being installed, updated, or removed.

> Keep in mind, `--on-event` functions must be loaded when their event is emitted. So, place your event handlers in the `conf.d` directory.

```fish
# Defined in flipper/conf.d/flipper.fish

function _flipper_install --on-event flipper_install
    # Set universal variables, create bindings, and other initialization logic.
end

function _flipper_update --on-event flipper_update
    # Migrate resources, print warnings, and other update logic.
end

function _flipper_uninstall --on-event flipper_uninstall
    # Erase "private" functions, variables, bindings, and other uninstall logic.
end
```

## Creating a theme

A theme is like any other Fish plugin, but with a `.theme` file in the `themes` directory. Themes were introduced in [Fish `3.4`](https://github.com/fish-shell/fish-shell/releases/tag/3.4.0) and work with the `fish_config` builtin. A theme can also have files in `functions`, `conf.d`, or `completions` if necessary. Check out what a typical theme plugin looks like:

<pre>
<b>gills</b>
├── <b>conf.d</b>
│   └── gills.fish
└── <b>themes</b>
    └── gills.theme
</pre>

### Using `$fisher_path` with themes

If you customize `$fisher_path` to use a directory other than `$__fish_config_dir`, your themes won't be available via `fish_config`. That's because Fish expects your themes to be in `$__fish_config_dir/themes`, not `$fisher_path/themes`. This isn't configurable in Fish yet, but there's [a request to add that feature](https://github.com/fish-shell/fish-shell/issues/9456).

Fear not! You can easily solve this by symlinking Fisher's `themes` directory into your Fish config. First, backup any existing themes directory.

```console
mv $__fish_config_dir/themes $__fish_config_dir/themes.bak
```

Next, create a symlink for Fisher's themes directory.

```console
ln -s $fisher_path/themes $__fish_config_dir/themes
```

Want to use theme plugins and maintain your own local themes? You can do that too ([#708](https://github.com/jorgebucaran/fisher/issues/708)).

## Discoverability

While Fisher doesn't rely on a central plugin repository, discovering new plugins doesn't have to feel like navigating uncharted waters. To boost your plugin's visibility and make it easier for users to find, [add relevant topics to your repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/classifying-your-repository-with-topics#adding-topics-to-your-repository) using [`fish-plugin`](https://github.com/topics/fish-plugin). By doing so, you're not only contributing to the Fisher community but also enabling users to explore new plugins and enhance their Fish shell experience. Don't let plugin discovery be a fishy business, tag your plugins today!

## Acknowledgments

Fisher started its journey in 2016 by [@jorgebucaran](https://github.com/jorgebucaran) as a shell configuration manager for Fish. Along the way, many helped shape it into what it is today. [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish) paved the way as the first popular Fish framework. [@jethrokuan](https://github.com/jethrokuan) provided crucial support during the early years. [@PatrickF1](https://github.com/PatrickF1)'s candid feedback proved invaluable time and again. Bootstrapping Fisher was originally [@IlanCosman](https://github.com/IlanCosman)'s brilliant idea. Thank you to all our contributors! <3

## License

[MIT](LICENSE.md)
