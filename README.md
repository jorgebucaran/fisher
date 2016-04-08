<a name="fisherman"></a>

<h1 align="center">
    <br>
    <br>
    <br>
    <a href="http://fisherman.sh"><img
        alt="Fisherman"
        width=700px
        src="https://rawgit.com/fisherman/logo/master/fisherman-black-white.svg"></a>
    <br>
    <br>
    <br>
    <br>
</h1>

**[Fisherman]** is a blazing fast, parallel plugin manager for [fish].

```fish
curl -sL get.fisherman.sh | fish
```

[![play]][play-link]

<sub>现在提供中文支持,若有疑问,可以中文提交ISSUE,我们会尽快解决,感谢您的支持</sub>



[![Build Status][travis-badge]][travis-link]
[![Fisherman Version][version-badge]][version-link]
[![Slack Room][slack-badge]][slack-link]


## Install

```fish
curl -sL get.fisherman.sh | fish
```

<sub>See [other] install options.</sub>

## CLI

The Fisherman CLI consists of: **i**nstall, **u**pdate, uninstall, **l**ist, **s**earch and **h**elp.

### Examples

* Install plugins.

```
fisher i fishtape shark get bobthefish
```

* Install Oh My Fish! plugins.

```fish
fisher i omf/plugin-{percol,jump,fasd}
```

* Install a plugin from a local directory.

```fish
fisher i ./path/to/plugin
```

* Install a plugin from various URLs.

```fish
fisher i https://github.com/some/plugin another/plugin bb:one/more
```

* Install a plugin from a Gist.

```fish
fisher i gist.github.com/owner/1f40e1c6e0551b2666b2
```

* Update everything.

```
fisher u
```

* Update plugins.

```
fisher u shark get
```

* Uninstall plugins.

```
fisher uninstall fishtape debug
```

* Get help.

```fish
fisher h
```

## List and search

The list command displays all the plugins you have installed. The search command queries the index to show what's available to install.

List installed plugins.

```
fisher list
  debug
  fishtape
  spin
> superman
@ wipe
```

Search the index.

```
fisher search
  ...
* debug        Conditional debug logger
  errno        POSIX error code/string translator
* fishtape     TAP producing test runner
  flash        Flash-inspired, thunder prompt
  fzf          Efficient keybindings for fzf
  get          Press any key to continue
  ...
> superman     Powerline prompt based on Superman
  ...
```

Query the index using regular expressions.

```
fisher search --name~/git-is/
git-is-dirty       Test if there are changes not staged for commit
git-is-empty       Test if a repository is empty
git-is-repo        Test if the current directory is a Git repo
git-is-staged      Test if there are changes staged for commit
git-is-stashed     Test if there are changes in the stash
git-is-touched     Test if there are changes in the working tree
```

Search using tags.

```
fisher search --tag={git,test}
  ...
  * fishtape         TAP producing test runner
  git-branch-name    Get the name of the current Git branch
  git-is-dirty       Test if there are changes not staged for commit
  git-is-empty       Test if a repository is empty
  git-is-repo        Test if the current directory is a Git repo
  git-is-staged      Test if there are changes staged for commit
  git-is-stashed     Test if there are changes in the stash
  git-is-touched     Test if there are changes in the working tree
  ...
```

The legend consists of:

* `>` The plugin is a prompt
* `*` The plugin is installed
* `@` The plugin is a symbolic link


## Plumbing

Fisherman commands are pipe aware. Plumb one with another to create complex functionality.

Update plugins installed as symbolic links.

```fish
fisher list --link | fisher update -
```

Enable all the plugins currently disabled.

```fish
fisher list --disabled | fisher install
```

Uninstall all the plugins and remove them from the cache.

```fish
fisher list | fisher uninstall --force
```

## Dotfiles

When you install a plugin, Fisherman updates the *fishfile* to track what plugins are currently enabled.

* Customize the location of the fishfile.

```fish
set -g fisher_file ~/.dotfiles/fishfile
```

## Flat Tree

Fisherman merges the directory trees of all the plugins it installs into a single flat tree. Since the flat tree is loaded only once at the start of the shell, Fisherman performs equally well, regardless of the number of plugins installed.

The following illustrates an example Fisherman configuration path with a single plugin and prompt.

```
$fisher_config
├── cache
├── completions
│   └── my_plugin.fish
├── conf.d
│   └── my_plugin.fish
├── fishfile
├── functions
│   ├── fish_prompt.fish
│   ├── fish_right_prompt.fish
│   └── my_plugin.fish
└── man
    └── man1
        └── my_plugin.1
```

## Index

The index is a plain text database that lists Fisherman official plugins.

The index lists records, each consisting the fields: *name*, *url*, *info*, one or more *tags* and *author*.

```
z
https://github.com/fishery/fish-z
Pure-fish z directory jumping
z search cd jump
jethrokuan
```

If you have a plugin you would like to submit to the index, send us a PR here [index](https://github.com/fisherman/fisher-index) repository.

```
git clone https://github.com/fisherman/index
cd index
echo "$name\n$url\n$info\n$tags\n$author\n\n" >> index
git push origin master
```

## Variables

* $fisher_home:
    The home directory. If you installed Fisherman using the recommended method, the location ought to be *XDG_DATA_HOME/fisherman*.

* $fisher_config:
    The configuration directory. This is default location of your *fishfile*, *key_bindings.fish*, *cache*, *functions*, *completions* and *conf.d* directories. *XDG_CONFIG_HOME/fisherman* by default.

* $fisher_file:
    See [fishfile](#fishfile) above.

* $fisher_cache:
    The cache directory. Plugins are downloaded to this location.

* $fisher_alias *command*=*alias* ...:
    Use this variable to create aliases of Fisherman commands.

[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square

[version-badge]: https://img.shields.io/badge/latest-v1.4.0-00B9FF.svg?style=flat-square
[version-link]: https://github.com/fisherman/fisherman/releases

[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square

[play]: https://cloud.githubusercontent.com/assets/8317250/13458315/dfcac4b4-e0af-11e5-8ee5-df31d1cdf409.png
[play-link]: http://fisherman.sh/#demo

[Get Started]: https://github.com/fisherman/fisherman/wiki
[Plugins]: http://fisherman.sh/#search
[fish]: https://github.com/fish-shell/fish-shell

[other]: https://github.com/fisherman/fisherman/wiki/Installing-Fisherman#notes
[Fisherman]: http://fisherman.sh
[new]: https://github.com/fishery/new
