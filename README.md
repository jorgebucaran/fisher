[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organization]: https://github.com/fisherman
[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[online]: http://fisherman.sh/#search

[Español]: docs/es-ES
[简体中文]: docs/zh-CN
[日本語]: docs/jp-JA
[Русский]: docs/ru-RU

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

fisherman is a concurrent plugin manager for the [fish shell].

Read this document in another language: [Español], [日本語], [简体中文], [Русский].

## Why?

* Simple

* No configuration

* No external dependencies

* No impact on shell startup time

* Use it interactively or _a la_ vundle

* Only the essentials, install, update, remove, list and help

## Install

With curl.

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

With npm.

```
npm i -g fisherman
```

## Usage

Install a plugin.

```
fisher simple
```

Install from multiple sources.

```
fisher z fzf omf/{grc,thefuck}
```

Install from a URL.

```
fisher https://github.com/edc/bass
```

Install from a gist.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Install from a local directory.

```sh
fisher ~/my_aliases
```

Use it a la vundle. Edit your fishfile and run `fisher` to satisfy changes.

> [What is a fishfile and how do I use it?](#6-what-is-a-fishfile-and-how-do-i-use-it)

```sh
$EDITOR fishfile # add plugins
fisher
```

See what's installed.

```
fisher ls
@ my_aliases    # this plugin is a local directory
* simple        # this plugin is the current prompt
  bass
  fzf
  grc
  thefuck
  z
```

Update everything.

```
fisher up
```

Update some plugins.

```
fisher up bass z fzf thefuck
```

Remove plugins.

```
fisher rm simple
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

### 1. What is the required fish version?

fisherman was built for fish >= 2.3.0. If you are using 2.2.0, append the following code to your `~/.config/fish/config.fish` for [snippet](#8-what-is-a-plugin) support.

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. How do I use fish as my default shell?

Add fish to the list of login shells in `/etc/shells` and make it your default shell.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 3. How do I uninstall fisherman?

```fish
fisher self-uninstall
```

or

```
npm un -g fisherman
```

### 4. Is fisherman compatible with oh my fish themes and plugins?

Yes.

### 5. Where does fisherman put stuff?

fisherman goes in `~/.config/fish/functions/fisher.fish`.

The cache and plugin configuration is created in `~/.cache/fisherman` and `~/.config/fisherman` respectively.

The fishfile is saved to `~/.config/fish/fishfile`.

### 6. What is a fishfile and how do I use it?

The fishfile `~/.config/fish/fishfile` lists all the installed plugins.

You can let fisherman take care of this file for you automatically, or write in the plugins you want and run `fisher` to satisfy the changes.

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

This mechanism only installs plugins and missing dependencies. To remove a plugin, use `fisher rm` instead.

### 7. Where can I find a list of fish plugins?

Browse the [organization] or use the [online] search to discover content.

### 8. What is a plugin?

A plugin is:

1. a directory or git repo with a function `.fish` file either at the root level of the project or inside a `functions` directory

2. a theme or prompt, i.e, a `fish_prompt.fish`, `fish_right_prompt.fish` or both files

3. a snippet, i.e, one or more `.fish` files inside a directory named `conf.d` that are evaluated by fish at the start of the shell

### 9. How can I list plugins as dependencies to my plugin?

Create a new `fishfile` file at the root level of your project and write in the plugin dependencies.

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```
