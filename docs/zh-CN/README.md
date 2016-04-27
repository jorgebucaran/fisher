[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organization]: https://github.com/fisherman
[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[online]: http://fisherman.sh/#search

[English]: ../../README.md
[Español]: ../es-ES
[日本語]: ../jp-JA
[Русский]: ../ru-RU
[한국어]: ../ko-KR
[Català]: ../ca-ES

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

fisherman 是一款零配置，并发的 [fish shell] 插件管理器。

选择不同语言版本的文档: [Español], [日本語], [English], [한국어], [Русский], [Català]。

##为什么使用fisherman？

* 零配置

* 没有其他依赖

* 不影响 shell 启动速度

* 类似 [vundle](https://github.com/VundleVim/Vundle.vim) 的交互下载功能

* 实现了最核心的功能: 安装、更新、移除和查询插件

## 安装

使用curl。

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

使用npm。

```sh
npm i -g fisherman
```

如果你仍然在使用 fisherman 1.5 并且想轻松升级到 2.0以上， 可以执行以下命令
```sh
curl -L git.io/fisher-up-me | fish
```

## 功能

安装插件。

```
fisher simple
```

从多个源安装插件。

```
fisher z fzf omf/{grc,thefuck}
```

从 URL 安装插件。

```
fisher https://github.com/edc/bass
```

从 Gist 安装插件。

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

从本地目录安装插件。

```sh
fisher ~/my_aliases
```

使用 [vundle](https://github.com/VundleVim/Vundle.vim) 的方式安装插件，编辑你的 fishfile 并运行 `fisher` 去安装插件。

> [什么是 fishfile 以及如何使用它?](#6-什么是-fishfile-以及如何使用它)

```sh
$EDITOR fishfile # 添加插件
fisher
```

查看以安装的插件。

```ApacheConf
fisher ls
@ my_aliases    # 该插件是一个本地插件
* simple        # 该插件是当前的命令行提示符插件
  bass
  fzf
  grc
  thefuck
  z
```

更新所有。

```
fisher up
```

更新指定的插件。

```
fisher up bass z fzf thefuck
```

移除指定的插件。

```
fisher rm simple
```

移除所有的插件。

```
fisher ls | fisher rm
```

查看插件帮助。

```
fisher help z
```

## 常见疑问解答

### 1. fish 的版本要求多少？

fisherman 要求 2.3.0 及以上版本的 fish。如果正在使用 2.2.0 版本，你可以写入以下[代码片段](#8-什么是一个插件)到你的 `~/.config/fish/config.fish`。

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. 如何让 fish 作为我默认的 shell ?

Add fish to the list of login shells in `/etc/shells` and make it your default shell.
把 fish 加入到 `/etc/shells` 并令 fish 成为默认 shell。

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 3. 如何卸载 fisherman？

运行以下命令。

```fish
fisher self-uninstall
```

或者

```fish
npm un -g fisherman
```

### 4. fisherman 兼容已有的 fish 主题和插件吗？

是的。

### 5. fisherman 把数据放到哪里了？

fisherman 的位置在 `~/.config/fish/functions/fisher.fish`。
缓存和插件配置被分别存在 `~/.cache/fisherman` 和 `~/.config/fisherman`。
fishfile 位置在 `~/.config/fish/fishfile`。

### 6. 什么是 fishfile 以及如何使用它？

fishfile `~/.config/fish/fishfile` 列出了所有已安装的插件。

fisherman 安装插件时，会自动写入这个文件，或者你可以手动写入你想装的插件，然后运行 `fisher` 来安装插件

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

这个文件只会记录插件和一些依赖。如果你想卸载插件，可以使用 `fisher rm`来替代。

### 7. 去哪里可以找到插件？

看看这个 [organization] 或者使用这个 [online] 来搜索。

### 8. 什么是一个插件？

一个插件是：

1. 一个目录或者一个在项目根目录有 `.fish` 文件或者 `functions` 目录的git仓库

2. 一个主题或者命令行提示符，比如 `fish-prompt.fish`, `fish_right_prompt.fish`。

3. 一些代码片段，比如一个或多个在 `conf.d`目录下的 `.fish` 文件，并且它们会在 shell 启动时执行。

### 9. 如何把这些插件作为我自己插件的依赖？

在项目的顶层目录创建一个新的 `fishfile` 文件，并写下你的依赖。

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```
