[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[fish]: https://fish.sh
[fisherman]: http://fisherman.sh

[日本語]: https://github.com/fisherman/fisherman/wiki/%E6%97%A5%E6%9C%AC%E8%AA%9E
[繁體中文]: https://github.com/fisherman/fisherman/wiki/%E7%B9%81%E9%AB%94%E4%B8%AD%E6%96%87
[简体中文]: https://github.com/fisherman/fisherman/wiki/%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87
[한국어]: https://github.com/fisherman/fisherman/wiki/%ED%95%9C%EA%B5%AD%EC%96%B4
[Русский]: https://github.com/fisherman/fisherman/wiki/%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9
[Català]: https://github.com/fisherman/fisherman/wiki/Catal%C3%A0
[Português]: https://github.com/fisherman/fisherman/wiki/Portugu%C3%AAs
[Español]: https://github.com/fisherman/fisherman/wiki/Espa%C3%B1ol
[Deutsch]: https://github.com/fisherman/fisherman/wiki/Deutsch
[فارسی]: https://github.com/fisherman/fisherman/wiki/%D9%81%D8%A7%D8%B1%D8%B3%DB%8C
[Français]: https://github.com/fisherman/fisherman/wiki/Fran%C3%A7ais
[Türkçe]: https://github.com/fisherman/fisherman/wiki/T%C3%BCrk%C3%A7e

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman]

A plugin manager for [fish].

Translations: [日本語], [繁體中文], [简体中文], [한국어], [Русский], [Português], [Türkçe], [Español], [Français], [Català], [Deutsch], [فارسی].

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

Show additional information about available plugins:

```
fisher ls-remote --format="%name(%stars): %info [%url]\n"
```

Update everything.

```
fisher up
```

Update plugins.

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

1. a directory with one or more .fish functions either at the root level of the project or inside a functions directory

2. a theme or prompt: a fish_prompt.fish and/or fish_right_prompt.fish

3. a snippet: one or more .fish files inside a directory named *conf.d*, run by fish at the start of the session

### How can I list plugins as dependencies to my plugin?

Create a new fishfile at the root level of your project and write the plugin URL such as *github.com/owner/repo*.

### Why am I receiving errors when running `fisher ls-remote`?

You can export the GITHUB_USER and GITHUB_TOKEN environment variables in your shell, to prevent GitHub's search API from rejecting anonymous requests:

```fish
set -x GITHUB_USER your_username
set -x GITHUB_TOKEN your_github_api_token_for_fisherman
```
