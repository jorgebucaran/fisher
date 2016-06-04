[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[fish]: https://fish.sh
[fisherman]: http://fisherman.sh

[日本語]: https://github.com/fisherman/fisherman/wiki/%E6%97%A5%E6%9C%AC%E8%AA%9E
[简体中文]: https://github.com/fisherman/fisherman/wiki/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87
[한국어]: https://github.com/fisherman/fisherman/wiki/%ED%95%9C%EA%B5%AD%EC%96%B4
[Русский]: https://github.com/fisherman/fisherman/wiki/%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9
[Català]: https://github.com/fisherman/fisherman/wiki/Catal%C3%A0
[Português]: https://github.com/fisherman/fisherman/wiki/Portugu%C3%AAs
[Español]: https://github.com/fisherman/fisherman/wiki/Espa%C3%B1ol
[Deutsch]: https://github.com/fisherman/fisherman/wiki/Deutsch
[فارسی]: https://github.com/fisherman/fisherman/wiki/%D9%81%D8%A7%D8%B1%D8%B3%DB%8C

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman]

A plugin manager for [fish].

Translations: [日本語], [简体中文], [한국어], [Русский], [Português], [Español], [Català], [Deutsch], [فارسی].

## Install

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
```

## Usage

Install a plugin.

```
fisher mono
```

Install some plugins.

```
fisher z fzf edc/bass omf/thefuck
```

Install a gist.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Install a local directory.

```sh
fisher ~/my/plugin
```

Edit your [fishfile](#what-is-a-fishfile-and-how-do-i-use-it) and run `fisher` to commit changes.

```sh
$EDITOR ~/.config/fish/fishfile
fisher
```

Show everything you've installed.

```ApacheConf
fisher ls
@ plugin     # a local plugin
* mono       # current theme
  bass
  fzf
  thefuck
  z
```

Show everything that's available.

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

## FAQ

### What is the required fish version?
[2.3.0]: https://github.com/fish-shell/fish-shell/releases/tag/2.3.0

\>=2.2.0.

For [snippet](#what-is-a-plugin) support, upgrade to >=[2.3.0] or append the following code to your ~/.config/fish/config.fish.

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### Is fisherman compatible with oh-my-fish themes and plugins?

Yes.

### Where does fisherman put stuff?

The configuration and cache are saved to ~/.config/fisherman and ~/.cache/fisherman respectively.

The fishfile and plugins are saved to ~/.config/fish by default.

To customize this location:

```fish
set -U fish_path ~/my/path
```

### What is a fishfile and how do I use it?

The fishfile lists what you've installed, and it's automatically updated as you install / remove plugins.

If you prefer, you can edit this file and run `fisher` to install missing plugins and dependencies.

### What is a plugin?

A plugin is:

1. a directory or git repo with one or more .fish functions either at the root level of the project or inside a functions directory

2. a theme or prompt, i.e, a fish_prompt.fish, fish_right_prompt.fish or both files

3. a snippet, i.e, one or more .fish files inside a directory named *conf.d*, evaluated by fish at the start of the session

### How can I list plugins as dependencies to my plugin?

Create a new fishfile at the root level of your project and write the plugin URL such as *github.com/owner/repo*.
