# Fisher

[![Build Status](https://img.shields.io/travis/jorgebucaran/fisher.svg)](https://travis-ci.org/jorgebucaran/fisher)
[![Releases](https://img.shields.io/github/release/jorgebucaran/fisher.svg?label=latest)](https://github.com/jorgebucaran/fisher/releases)

Fisher is a package manager for the [fish shell](https://fishshell.com). It defines a common interface for package authors to build and distribute their shell scripts in a portable way. You can use it to extend your shell capabilities, change the look of your prompt and create repeatable configurations across different systems effortlessly.

## Features

- Zero configuration
- Oh My Fish package support
- High-speed concurrent package downloads⌁!
- If you've installed a package before, then it can be installed again offline
- Add, update and remove functions, completions, keybindings and configuration snippets from a variety of sources using the command line or editing your [fishfile](#using-the-fishfile)

## Installation

Download fisher to your fish functions directory or any directory in your $fish_function_path.

<!-- Notice we're just copying a file to a directory—this is not a curlpipe installer. -->

```fish
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
```

If the [XDG_CONFIG_HOME](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables) environment variable is defined on your system, use $XDG_CONFIG_HOME/fish to resolve the path to your fish configuration directory instead of ~/.config/fish.

### Dependencies

- [fish](https://github.com/fish-shell/fish-shell) 2.0+ (prefer 2.3 or newer)
- [curl](https://github.com/curl/curl) 7.10.3+
- [git](https://github.com/git/git) 1.7.12+

### Legacy fish support

Stuck in legacy fish and can't upgrade your shell? You'll need to run some code on startup to support packages that use [configuration snippets](#configuration-snippets). Open your ~/.config/fish/config.fish and add the following code at the beginning of the file.

```fish
set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
for file in $XDG_CONFIG_HOME/conf.d/*.fish
    builtin source $file 2>/dev/null
end
```

### Bootstrap installation

To automate installing fisher on a new system, add the following code to your ~/.config/fish/config.fish. This will download fisher and install all the packages listed in your [fishfile](#using-the-fishfile) (if there is one).

```fish
if not functions -q fisher
    echo "Installing fisher for the first time..." >&2
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fisher
end
```

### Changing the installation prefix

Use the `$fisher_path` environment variable to change the prefix location where functions, completions, and configuration snippets will be copied to when a package is installed. The default location is where fisher itself is installed. If you followed the installation instructions above it should be in ~/.config/fish.

Make sure to append your functions and completions directories to the `$fish_function_path` and `$fish_complete_path` environment variables so that they can be autoloaded by fish in future sessions and to source every fish file inside your conf.d directory to run configuration snippets on startup.

Here is a boilerplate configuration you can add to your ~/.config/fish/config.fish file to get you started.

```fish
set -g fisher_path ~/another/path

set fish_function_path $fish_function_path $fisher_path/functions
set fish_complete_path $fish_complete_path $fisher_path/completions

for file in $fisher_path/conf.d/*.fish
    builtin source $file 2> /dev/null
end
```

### Migrating from V2 to V3

The easiest way to upgrade to V3 from V2 is to uninstall V2 first using:

```
fisher self-uninstall
``` 

...and install V3 from scratch using the recommended [installation instructions](https://github.com/jorgebucaran/fisher#installation). See [#450](https://github.com/jorgebucaran/fisher/issues/450) for more options.


## Usage

You've found an interesting utility you'd like to try out. Or perhaps you've [created a package](#creating-your-own-package) yourself. How do you install it on your system? You may want to update or remove it later too. How do you do that?

You can use fisher to add, update and remove packages interactively, taking advantage of fish tab completions and syntax highlighting. Or [edit your fishfile](#using-the-fishfile) and commit your changes. Do you prefer a CLI-centered approach, text-based approach, or both?

### Adding packages

Install packages using the `add` command.

```
fisher add jethrokuan/z rafaelrinaldi/pure
```

Packages will be downloaded from GitHub if the name of the host is not specified. To install a package hosted anywhere else use the address of the remote server and the path to the repository.

```
fisher add gitlab.com/owner/foobar bitbucket.org/owner/fumbam
```

Install a package from a tag or a branch.

```
fisher add jethrokuan/z@pre27
```

Install a package from a local directory. Local packages are managed through [symbolic links](https://en.wikipedia.org/wiki/Symbolic_link), so you can develop and use them at the same time.

```
fisher add ~/myfish/mypkg
```

Notice you can only install one package version at a time. If two packages depend on a different version of the same package, the first one that gets installed will take precedence over the other.

### Listing packages

List all the packages that are currently installed using the `ls` command. This includes packages you didn't install yourself but were installed on your system as a dependency of another package.

```
fisher ls
jethrokuan/z@pre27
rafaelrinaldi/pure
~/myfish/mypkg
gitlab.com/owner/foobar
bitbucket.org/owner/fumbam
```

### Removing packages

Remove packages using the `rm` command. If a package has dependencies, they too will be removed. If any dependencies are still shared by other packages, they will remain installed.

```
fisher rm rafaelrinaldi/pure
```

You can remove everything that is currently installed in one sweep using the following pipeline.

```sh
fisher ls | fisher rm
```

### Updating packages

Run `fisher` to update everything you've installed. There is no dedicated update command. Using the command line to add and remove packages is a facade for modifying and committing changes to your fishfile in a single step.

If you are looking for a way to update fisher itself, use the `self-update` command.

```
fisher self-update
```

### Other commands

To display usage help use the `help` command.

```
fisher help
```

Last but not least use the `version` command to display the current version of fisher.

```
fisher version
```

### Using the fishfile

Whenever you add or remove a package from the command line we'll create a text file in ~/.config/fish/fishfile. This is your fishfile. It lists every package that is currently installed on your system. You should add this file to your dotfiles or version control if you want to reproduce your configuration on a different system.

You can edit this file to add or remove packages and then run `fisher` to commit your changes. Only packages listed in the file will be installed after fisher returns. If a package is already installed it will be updated. Empty lines and everything after a `#` (comments) will be ignored.

```fish
vi ~/.config/fish/fishfile
```

```fish
rafaelrinaldi/pure
jethrokuan/z@pre27

# my local packages
~/myfish/mypkg
```

```
fisher
```

## Package concepts

Packages help you organize shell scripts into reusable, independent components that can be shared through a git URL or the path to a local directory. Even if your package is not meant to be shared with others, you can benefit from composition and the ability to depend on other packages.

A package is uniquely identified by the name of its host, owner and root directory. Alas, the lack of private function scope in fish causes all package functions to share the same namespace. A good rule of thumb is to prefix functions intended for private use with the name of your package to reduce the possibility of conflicts.

The structure of a package can be adopted from the fictional project described below. These are the files that fisher looks for when installing or uninstalling a package. Of course, you can elaborate on this to add tests, documentation, and other files, e.g. README and LICENSE files. The name of the root directory can be anything you wish. I recommend using a naming convention such as fish-_package-name_ for easier classification.

```
fish-fly
├── fishfile
├── functions
│   └── fly.fish
├── completions
│   └── fly.fish
└── conf.d
    └── fly.fish
```

If your project depends on other packages, it should list them as dependencies in a fishfile. There is no need for a fishfile otherwise. The rules concerning the usage of the fishfile are the same rules we've already covered in [using the fishfile](#using-the-fishfile).

While some packages contain every kind of file, some packages contain only functions or configuration snippets. You are not limited to a single file per directory either. There can be as many files as you need or only one as in the next example.

```
fish-fly
└── fly.fish
```

### Creating your own package

The best way to show you how to create your own package is by building one together. Our first example will be a function that prints the raw non-rendered markdown source of a README file from GitHub to standard output. Its inputs will be the name of the owner, repository, and branch. If no branch is specified, we'll use the master branch.

Create the following directory structure and function file. Make sure the function name matches the file name, otherwise fish won't be able to autoload it the first time you try to use it.

```
fish-readme
└── readme.fish
```

```fish
function readme --argument owner repo branch
    if test -z "$branch"
        set branch master
    end
    curl -s https://raw.githubusercontent.com/$owner/$repo/$branch/README.md
end
```

You can install it with the `add` command followed by the path to the directory. Local packages are symlinked to your `$fisher_path` so that code changes are instantly reflected during development.

```
fisher add /absolute/path/to/fish-readme
```

The next logical step is to share it with others. How do you do that? Fisher is not a package registry. Its function is to fetch fish scripts and put them in place so that your shell can find them. To publish a package put your code online. You can use GitHub, GitLab or BitBucket or anywhere you like.

Now let's install the package again, this time from its new location. Open your ~/.config/fish/fishfile and replace the local version of the package we previously installed with the URL of the remote repository. Save your changes and run `fisher`. You can leave off the github.com part of the URL when adding or removing packages hosted on GitHub.

### Configuration snippets

Configuration snippets consist of any fish files in your ~/.config/fish/conf.d directory. They are evaluated on [shell startup](http://fishshell.com/docs/current/index.html#initialization) and often used to modify the shell environment, create key bindings, etc.

Unlike functions or completions, which can be erased programmatically, we can't undo a fish file that has been sourced without creating a new shell session. For this reason, packages that use configuration snippets provide custom uninstall logic through an uninstall [event handler](https://fishshell.com/docs/current/#event).

Let's walk through an example that uses this feature to add a new key binding. Key bindings (or keyboard shortcuts) are sequences of one or more keys mapped to a fish command, builtin or function. The following package maps the sequence `Control-g` to opening your fishfile in the `vi` editor.

```
fish-fishfile-quick-edit
└── conf.d
    └── fishfile-quick-edit.fish
```

```fish
bind \cg "vi ~/.config/fish/fishfile"

function fishfile-quick-edit_uninstall --event fishfile-quick-edit_uninstall
    bind -e \cg
end
```

When you uninstall this package, we'll emit a _package-name_\_uninstall event that will call your eponymously named event handler function where the key binding will be erased.

> **Note**: Custom key bindings on shell startup are only available on fish 3.0 or newer. To make this package compatible with older versions of fish, you need to add custom key bindings via [jorgebucaran/fish-custom-key-bindings](https://github.com/jorgebucaran/fisher/issues/448).

## Uninstalling

You wish to know how to uninstall fisher and everything you've installed with it from your system. Or perhaps something went wrong and you want to start over. This will uninstall all the packages, purge the cache and then remove fisher from your fish functions directory.

```fish
fisher self-uninstall
```

## License

Fisher is MIT licensed. See the [LICENSE](LICENSE.md) for details.
