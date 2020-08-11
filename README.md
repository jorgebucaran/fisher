# Fisher

> A plugin manager for [fish](https://fishshell.com)—the friendly interactive shell.

Manage functions, completions, bindings, and snippets from the command line. Extend your shell capabilities, change the look of your prompt and create repeatable configurations across different systems effortlessly.

- Oh My Fish! plugin support.
- Build and distribute shell scripts in a portable way.
- Insanely fast concurrent plugin downloads with built-in cache fallback.
- Zero configuration out of the box. Need to tweak a thing? You can do that too.

Fishing for plugins? Browse [git.io/awesome.fish](https://git.io/awesome.fish) or [search](https://github.com/topics/fish-packages) [on](https://github.com/topics/fish-plugins) [GitHub](https://github.com/topics/fish-plugin).

## Installation

Just drop [`fisher.fish`](fisher.fish) on any directory in your function path and you are done.

```console
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
```

## Quickstart

You've found an interesting utility you'd like to try out. Or maybe you've [created a new plugin](#creating-your-own-plugin). How do you install it? How to update or remove it?

You can use Fisher to add, update, and remove plugins interactively, taking advantage of fish [tab completion](https://fishshell.com/docs/current/index.html#completion) and syntax highlighting. Or [edit your fishfile](#using-the-fishfile) and commit your changes. Do you prefer a CLI-centered approach, text-based approach, or a mix of both?

### Adding plugins

Add plugins using the `add` command followed by the path to the repository on GitHub.

```console
fisher add jethrokuan/z rafaelrinaldi/pure
```

To add a plugin from a different location, use the address of the server and the path to the repository. HTTPS is always assumed, so you don't need to specify the protocol.

```console
fisher add gitlab.com/big/fish
```

To add a plugin from a private repository set the `fisher_user_api_token` variable to your username followed by a colon and your authorization token or password.

```fish
set -g fisher_user_api_token jorgebucaran:ce04da9bd93ddb5e729cfff4a58c226322c8d142
```

For a specific version of a plugin add an `@` symbol after the plugin name followed by the tag, branch or [commit-ish](https://git-scm.com/docs/gitglossary#gitglossary-aiddefcommit-ishacommit-ishalsocommittish). Only one plugin version can be installed at any given time.

```console
fisher add edc/bass@20f73ef jethrokuan/z@pre27
```

You can add plugins from a local directory too. Local plugins will be installed as [symbolic links](https://en.wikipedia.org/wiki/Symbolic_link) so changes in the original files will be reflected in new shell sessions without having to re-run `fisher`.

```console
fisher add ~/path/to/local/plugin
```

### Listing plugins

List all the plugins that are currently installed using the `ls` command. This doesn't show plugin dependencies.

```console
fisher ls
jethrokuan/z
rafaelrinaldi/pure
gitlab.com/big/fish
edc/bass
~/path/to/myfish/plugin
```

You can use a regular expression after `ls` to refine the output.

```
fisher ls "^gitlab|fish-.*"
```

### Removing plugins

Remove plugins using the `rm` command. If a plugin has dependencies, they too will be removed. If any dependencies are still shared by other plugins, they will remain installed.

```console
fisher rm rafaelrinaldi/pure
```

You can remove everything that is currently installed in one sweep using the following pipeline.

```console
fisher ls | fisher rm
```

### Updating plugins

Run `fisher` to update everything currently installed. There is no dedicated update command. Using the command line to add and remove plugins is the easiest way to modify and commit changes to your fishfile.

Looking for a way to self update Fisher? Use the `self-update` command.

```console
fisher self-update
```

### Other commands

Display usage help on the command line.

```console
fisher --help
```

Display the current version of Fisher.

```console
fisher --version
```

Remove installed plugins, cache, your fishfile, and Fisher.

```console
fisher self-uninstall
```

## Changing the installation path

Fisher expands plugins into your fish configuration directory by default, overwriting existing files. To change this behavior, set `$fisher_path` to your preferred location and put it in your function path.

```fish
set -g fisher_path /path/to/another/location

set -p fish_function_path fish_function_path[1] $fisher_path/functions
set -p fish_complete_path fish_complete_path[1] $fisher_path/completions

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2>/dev/null
end
```

## Using the fishfile

Whenever you add or remove a plugin from the command-line, Fisher writes the exact list of installed plugins to `~/.config/fish/fishfile`. This is your fishfile. Add this file to your dotfiles or version control in order to reproduce your configuration on a different system.

You can also edit this file and run `fisher` to commit your changes. Only the plugins listed in this file will be installed (or remained installed) after `fisher` returns. If a plugin is already installed, it will be updated. Everything after a `#` symbol will be ignored.

```fish
vi ~/.config/fish/fishfile
```

```diff
- rafaelrinaldi/pure
- jethrokuan/z@pre27
gitlab.com/jorgebucaran/kraken
edc/bass
+ FabioAntunes/fish-nvm
~/path/to/myfish/plugin
```

```console
fisher
```

That will remove **rafaelrinaldi/pure** and **jethrokuan/z**, add **FabioAntunes/fish-nvm** and update the rest.

## What is a plugin?

plugins help you organize shell scripts into reusable, independent components that can be shared through a git URL or the path to a local directory. Even if your plugin is not meant to be shared with others, you can benefit from composition and the ability to depend on other plugins.

The structure of a plugin can be adopted from the fictional project described below. These are the files that Fisher looks for when installing or uninstalling a plugin. The name of the root directory can be anything you like.

```console
fish-kraken
├── fishfile
├── functions
│   └── kraken.fish
├── completions
│   └── kraken.fish
└── conf.d
    └── kraken.fish
```

If your project depends on other plugins, it should list them as dependencies in a fishfile. There is no need for a fishfile otherwise. The rules concerning the usage of the fishfile are the same rules we've already covered in [using the fishfile](#using-the-fishfile).

While some plugins contain every kind of file, some plugins include only functions or configuration snippets. You are not limited to a single file per directory either. There can be as many files as you need or just one as in the following example.

```
fish-kraken
└── kraken.fish
```

The lack of private scope in fish causes all plugin functions to share the same namespace. A good rule of thumb is to prefix functions intended for private use with the name of your plugin to prevent conflicts.

## Creating your own plugin

The best way to show you how to create your own plugin is by building one together. Our first example will be a function that prints the raw non-rendered markdown source of a README file from GitHub to standard output. Its inputs will be the name of the owner, repository, and branch. If no branch is specified, we'll use the master branch.

Create the following directory structure and function file. Make sure the function name matches the file name; otherwise fish won't be able to autoload it the first time you try to use it.

```
fish-readme
└── readme.fish
```

```fish
function readme -a owner repo branch
    if test -z "$branch"
        set branch master
    end
    curl -s https://raw.githubusercontent.com/$owner/$repo/$branch/README.md
end
```

You can install it with the `add` command followed by the path to the directory.

```console
fisher add /absolute/path/to/fish-readme
```

To publish the plugin upload it to GitHub, GitLab, BitBucket, or anywhere you like. Keep in mind that Fisher is not a plugin registry. Its function is to fetch fish scripts and put them in place so that your shell can find them.

Now let's install the plugin from the net. Open your [fishfile](#using-the-fishfile) and replace the local version of the plugin you added with the URL of the repository. Save your changes and run `fisher`.

```diff
- /absolute/path/to/fish-readme
+ gitlab.com/jorgebucaran/fish-readme
```

```console
fisher
```

You can leave off the `github.com` part of the URL when adding or removing plugins hosted on GitHub. If your plugin is hosted anywhere else, the address of the server is required.

## Plugin Events

> [Coming in Fisher 4](https://github.com/jorgebucaran/fisher/issues/582): `install` and `update`.

### `uninstall`

Plugins may provide custom uninstall logic through an uninstall [event handler](https://fishshell.com/docs/current/#event).

Let's walk through an example that uses this feature to add a new key binding for the Control-G sequence. Let's say we want to use it to open the fishfile in the `vi` editor quickly. When you install the plugin, `fishfile_quick_edit_key_bindings.fish` will be sourced, adding the specified key binding and loading the event handler function. When you uninstall it, Fisher will emit an uninstall event where you can erase the bindings!

```
fish-fishfile-quick-edit
└── conf.d
    └── fishfile_quick_edit_key_bindings.fish
```

```fish
bind \cg "vi ~/.config/fish/fishfile"

set -l name (basename (status -f) .fish)_uninstall

function $name --on-event $name
    bind --erase \cg
end
```

## License

[MIT](LICENSE.md)
