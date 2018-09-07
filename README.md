# [fisherman]

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

Fisherman is a [fish-shell] plugin manager.

## Install

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher
```

## Usage

Install a plugin.

```
fisher z
```

Install several plugins concurrently.

```
fisher fzf edc/bass omf/thefuck omf/theme-bobthefish
```

Install a specific branch.
```sh
fisher edc/bass:master
```

Install a specific tag.
```sh
fisher edc/bass@1.2.0
```

Install a gist.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Install a local plugin.

```sh
fisher ~/path/to/my_plugin
```

Edit your [**fishfile**](#what-is-a-fishfile-and-how-do-i-use-it) and run `fisher` to commit changes, e.g. install missing plugins.

```sh
$EDITOR ~/.config/fish/fishfile
fisher
```

Show everything you've installed.

```ApacheConf
fisher ls
@ my_plugin     # a local plugin
* bobthefish    # current theme
  bass
  fzf
  thefuck
  z
```

Show everything available to install.

```
fisher ls-remote
```

Show additional information about plugins:

```
fisher ls-remote --format="%name(%stars): %info [%url]\n"
```

Update everything.

```
fisher up
```

Update specific plugins.

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

## Bootstrap

If you want to automate installing fisherman in a new system when it isn't already installed, add the following at the top of your ~/.config/fish/config.fish.

This will install fisherman and download all the plugins listed in your _fishfile_.

```fish
if not test -f ~/.config/fish/functions/fisher.fish
  curl -sLo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisher
  fisher
end
```

## FAQ

### Is fisherman compatible with oh-my-fish themes and plugins?

Yes!

### How can I contribute to fisherman?

You are welcome to join the organization. Just [ask](https://fisherman-wharf.herokuapp.com/) and someone will send you an invite.

### Where does fisherman put stuff?

The configuration and cache are saved to ~/.config/fisherman and ~/.cache/fisherman respectively.

The fishfile and plugins are saved to ~/.config/fish by default.

To customize this location, add the following to your ~/.config/fish/config.fish file:

```fish
set -U fish_path ~/my/path

set fish_function_path $fish_path/functions $fish_function_path
set fish_complete_path $fish_path/completions $fish_complete_path

for file in $fish_path/conf.d/*.fish
  builtin source $file 2> /dev/null
end
```

### How do I have fisherman copy plugin files instead of linking?

By default, fisherman will create symlinks to plugin files.

To have fisherman copy files:

```fish
set -U fisher_copy true
```

### What is a fishfile and how do I use it?

The fishfile lists what you've installed, and it's automatically updated as you install / remove plugins.

You can edit this file and run `fisher` to install missing plugins and dependencies.

### What is a plugin?

A plugin is:

1. a directory with one or more .fish functions at the root level of the project or inside a functions/ directory

2. a theme or prompt: a fish_prompt.fish and/or fish_right_prompt.fish

3. a snippet: one or more .fish files inside a conf.d/ directory, run by fish at the start of the session

### How do I create my own plugins?

You can use [fishkit](https://github.com/fisherman/fishkit) to help you scaffold out a new project from scratch.

### How can I list plugins as dependencies to my plugin?

Create a new fishfile at the root level of your project and write the plugin URL like so *github.com/owner/repo*.

### Why am I receiving errors when running `fisher ls-remote`?

You can export the GITHUB_USER and GITHUB_TOKEN environment variables in your shell, to prevent GitHub's search API from rejecting anonymous requests:

```fish
set -x GITHUB_USER your_username
set -x GITHUB_TOKEN your_github_api_token_for_fisherman
```
If you don't have a GitHub API token, you can [generate one from account settings](https://blog.github.com/2013-05-16-personal-api-tokens/)

[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[fish]: https://github.com/fish-shell/fish-shell
[fish-shell]: https://github.com/fish-shell/fish-shell
[fisherman]: https://fisherman.github.io
