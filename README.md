[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[fish]: https://fish.sh
[fisherman]: http://fisherman.sh

[日本語]: docs/jp-JA
[简体中文]: docs/zh-CN
[한국어]: docs/ko-KR
[Русский]: docs/ru-RU
[Català]: docs/ca-ES
[Português]: docs/pt-PT
[Español]: docs/es-ES

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman]

A plugin manager for [fish].

Translations: [日本語], [简体中文], [한국어], [Русский], [Català], [Português], [Español].

## Install

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

## Usage

Install a plugin.

```
fisher real
```

Install from multiple sources.

```
fisher z fzf edc/bass omf/thefuck
```

Install a gist.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Install from a local directory.

```sh
fisher ~/plugin
```

Edit your [fishfile](#what-is-a-fishfile-and-how-do-i-use-it) and run `fisher` to apply changes.

```sh
$EDITOR ~/.config/fish/fishfile
fisher
```

List what you've installed.

```ApacheConf
fisher ls
@ plugin     # a local plugin
* real       # current prompt
  bass
  fzf
  thefuck
  z
```

List everything that's available.

```
fisher ls-remote
```

Update everything.

```
fisher up
```

Update some plugins.

```
fisher up bass z fzf
```

Remove plugins.

```
fisher rm thefuck
```

Remove all the plugins.

```
fisher ls | fisher rm
```

Get help.

```
fisher help z
```

Uninstall fisherman.

```
fisher self-uninstall
```

## FAQ

### What is the required fish version?

\>=2.2.0.

For [snippet](#what-is-a-plugin) support, upgrade to >=2.3.0 or append the following code to your *~/.config/fish/config.fish*.

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### Is fisherman compatible with oh-my-fish themes and plugins?

Yes.

### Where does fisherman put stuff?

The cache and configuration go in *~/.cache/fisherman* and *~/.config/fisherman* respectively.

The fishfile is saved to *~/.config/fish/fishfile*.

### What is a fishfile and how do I use it?

The fishfile *~/.config/fish/fishfile* lists all the installed plugins.

You can let fisherman take care of this file for you automatically, or write in the plugins you want and run `fisher` to satisfy the changes.

This mechanism only installs plugins and missing dependencies. To remove plugins, use `fisher rm`.

### What is a plugin?

A plugin is:

1. a directory or git repo with one or more *.fish* functions either at the root level of the project or inside a *functions* directory

2. a theme or prompt, i.e, a *fish_prompt.fish*, *fish_right_prompt.fish* or both files

3. a snippet, i.e, one or more *.fish* files inside a directory named *conf.d*, evaluated by fish at the start of the session

### How can I list plugins as dependencies to my plugin?

Create a new *fishfile* file at the root level of your project and write in the plugins you'd like to depend on.
