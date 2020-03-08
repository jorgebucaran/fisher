# Fisher [![Releases](https://img.shields.io/github/release/jorgebucaran/fisher.svg?label=&color=0080FF)](https://github.com/jorgebucaran/fisher/releases/latest)

Fisher is a package manager for the <a href="https://fishshell.com" title="friendly interactive shell">fish shell</a>. It defines a common interface for package authors to build and distribute shell scripts in a portable way. You can use it to extend your shell capabilities, change the look of your prompt and create repeatable configurations across different systems effortlessly.

Here's why you'll love Fisher:

- No configuration needed.
- Oh My Fish! package support.
- Blazing fast concurrent package downloads.
- Cached downloads—if you've installed a package before, you can install it again offline!
- Add, update and remove functions, completions, key bindings, and [configuration snippets](#configuration-snippets) from a variety of sources using the command line, editing your [fishfile](#using-the-fishfile) or both!

Looking for packages? Browse [git.io/awesome-fish](https://git.io/awesome-fish) or [search on GitHub](https://github.com/topics/fish-packages).

## Installation

Just download [`fisher.fish`](fisher.fish) to your functions directory (or any directory in your function path).

```console
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
```

Your shell can take a few seconds before loading newly added functions. If the `fisher` command is not immediately available, launch a new session or [replace](https://fishshell.com/docs/current/commands.html#exec) the running shell with a new one.

### System Requirements

- [fish](https://github.com/fish-shell/fish-shell) 2.2+
- [curl](https://github.com/curl/curl) [7.10.3](https://curl.haxx.se/changes.html#7_10_3)+
- [git](https://github.com/git/git) 1.7.12+

> Stuck in fish 2.0 and can't upgrade your shell? Check our [legacy fish support guide](https://github.com/jorgebucaran/fisher/issues/510) and good luck!

### Bootstrap installation

To automate the installation process in a new system, installing packages listed in your [fishfile](#using-the-fishfile), add the following code to your fish configuration file.

```fish
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end
```

### Changing the installation prefix

Use the `$fisher_path` environment variable to change the location where functions, completions, and configuration snippets will be copied to when a package is installed. The default location will be your fish configuration directory.

Just one rule: `fisher` owns `$XDG_CONFIG_HOME/fisher`, and uses it for its own purposes. Trying to use this path for your own `fisher` configs will break!

> **Note**: Do I need this? If you want to keep your own functions, completions, and configuration snippets separate from packages installed with Fisher, customize the installation prefix. If you prefer to keep everything in the same place, you can skip this.

```fish
set -g fisher_path /path/to/another/location

set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end
```

## Getting started

You've found an interesting utility you'd like to try out. Or maybe you've [created a package](#creating-your-own-package) yourself. How do you install it on your system? How do update or remove it?

You can use Fisher to add, update, and remove packages interactively, taking advantage of fish [tab completion](https://fishshell.com/docs/current/index.html#completion) and syntax highlighting. Or [edit your fishfile](#using-the-fishfile) and commit your changes. Do you prefer a CLI-centered approach, text-based approach, or a mix of both?

### Adding packages

Add packages using the `add` command followed by the path to the repository on GitHub.

```console
fisher add jethrokuan/z rafaelrinaldi/pure
```

To add a package from a different location, use the address of the server and the path to the repository. HTTPS is always assumed, so you don't need to write the protocol.

```console
fisher add gitlab.com/jorgebucaran/kraken
```

To add a package from a private repository set the `fisher_user_api_token` variable to your username followed by a colon and your authorization token or password.

```fish
set -g fisher_user_api_token jorgebucaran:ce04da9bd93ddb5e729cfff4a58c226322c8d142
```

For a specific version of a package add an `@` symbol after the package name followed by the tag, branch or [commit-ish](https://git-scm.com/docs/gitglossary#gitglossary-aiddefcommit-ishacommit-ishalsocommittish). Only one package version can be installed at any given time.

```console
fisher add edc/bass@20f73ef jethrokuan/z@pre27
```

You can add packages from a local directory too. Local packages are installed as [symbolic links](https://en.wikipedia.org/wiki/Symbolic_link) so changes in the original files will be reflected in future shell sessions without having to re-run `fisher`.

```console
fisher add ~/path/to/local/pkg
```

### Listing packages

List all the packages that are currently installed using the `ls` command. This doesn't show package dependencies.

```console
fisher ls
jethrokuan/z
rafaelrinaldi/pure
gitlab.com/jorgebucaran/kraken
edc/bass
~/path/to/myfish/pkg
```

You can use a regular expression after `ls` to refine the output.

```
fisher ls "^gitlab|fish-.*"
```

### Removing packages

Remove packages using the `rm` command. If a package has dependencies, they too will be removed. If any dependencies are still shared by other packages, they will remain installed.

```console
fisher rm rafaelrinaldi/pure
```

You can remove everything that is currently installed in one sweep using the following pipeline.

```console
fisher ls | fisher rm
```

### Updating packages

Run `fisher` to update everything that is currently installed. There is no dedicated update command. Using the command line to add and remove packages is a quick way to modify and commit changes to your fishfile in a single step.

Looking for a way to update fisher itself? Use the `self-update` command.

```console
fisher self-update
```

### Other commands

Use the `--help` command to display usage help on the command line.

```console
fisher --help
```

Last but not least, use the `--version` command to display the current version of Fisher.

```console
fisher --version
```

## Using the fishfile

Whenever you add or remove a package from the command-line, Fisher writes the exact list of installed packages to `~/.config/fish/fishfile`. This is your fishfile. Add this file to your dotfiles or version control in order to reproduce your configuration on a different system.

You can also edit this file and run `fisher` to commit your changes. Only the packages listed in this file will be installed (or remained installed) after `fisher` returns. If a package is already installed, it will be updated. Everything after a `#` symbol will be ignored.

```fish
vi ~/.config/fish/fishfile
```

```diff
- rafaelrinaldi/pure
- jethrokuan/z@pre27
gitlab.com/jorgebucaran/kraken
edc/bass
+ FabioAntunes/fish-nvm
~/path/to/myfish/pkg
```

```console
fisher
```

That will remove **rafaelrinaldi/pure** and **jethrokuan/z**, add **FabioAntunes/fish-nvm** and update the rest.

## Digging deeper

### What is a package?

Packages help you organize shell scripts into reusable, independent components that can be shared through a git URL or the path to a local directory. Even if your package is not meant to be shared with others, you can benefit from composition and the ability to depend on other packages.

The structure of a package can be adopted from the fictional project described below. These are the files that Fisher looks for when installing or uninstalling a package. The name of the root directory can be anything you like.

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

If your project depends on other packages, it should list them as dependencies in a fishfile. There is no need for a fishfile otherwise. The rules concerning the usage of the fishfile are the same rules we've already covered in [using the fishfile](#using-the-fishfile).

While some packages contain every kind of file, some packages include only functions or configuration snippets. You are not limited to a single file per directory either. There can be as many files as you need or just one as in the following example.

```
fish-kraken
└── kraken.fish
```

The lack of private scope in fish causes all package functions to share the same namespace. A good rule of thumb is to prefix functions intended for private use with the name of your package to prevent conflicts.

### Creating your own package

The best way to show you how to create your own package is by building one together. Our first example will be a function that prints the raw non-rendered markdown source of a README file from GitHub to standard output. Its inputs will be the name of the owner, repository, and branch. If no branch is specified, we'll use the master branch.

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

To publish your pacckage put your code on GitHub, GitLab, BitBucket, or anywhere you like. Fisher is not a package registry. Its function is to fetch fish scripts and put them in place so that your shell can find them. 

Now let's install the package from the net. Open your [fishfile](#using-the-fishfile) and replace the local version of the package you added with the URL of the repository. Save your changes and run `fisher`.

```diff
- /absolute/path/to/fish-readme
+ gitlab.com/jorgebucaran/fish-readme
```

```console
fisher
```

You can leave off the `github.com` part of the URL when adding or removing packages hosted on GitHub. If your package is hosted anywhere else, the address of the server is required.

### Configuration snippets

Configuration snippets consist of all the fish files inside your `~/.config/fish/conf.d` directory. They run on [shell startup](http://fishshell.com/docs/current/index.html#initialization) and generally used to set environment variables, add new key bindings, etc.

Unlike functions or completions which can be erased programmatically, we can't undo a fish file that has been sourced without creating a new shell session. For this reason, packages that use configuration snippets provide custom uninstall logic through an uninstall [event handler](https://fishshell.com/docs/current/#event).

Let's walk through an example that uses this feature to add a new key binding for the Control-G sequence. Let's say we want to use it to open the fishfile in the `vi` editor quickly. When you install the package, `fishfile_quick_edit_key_bindings.fish` will be sourced, adding the specified key binding and loading the event handler function. When you uninstall it, Fisher will emit an uninstall event.

```
fish-fishfile-quick-edit
└── conf.d
    └── fishfile_quick_edit_key_bindings.fish
```

```fish
bind \cg "vi ~/.config/fish/fishfile"

set -l name (basename (status -f) .fish){_uninstall}

function $name --on-event $name
    bind --erase \cg
end
```

## Uninstalling

This command also uninstalls all your packages and removes your fishfile.

```console
fisher self-uninstall
```

## License

[MIT](LICENSE.md)
