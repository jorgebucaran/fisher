[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organization]: https://github.com/fisherman
[fish]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[online]: http://fisherman.sh/#search

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman]

fisherman 是 [fish] 的插件管理器。

## 安装

使用curl。

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

## 功能

安装插件。

```
fisher sol 
```

从多个源安装插件。

```
fisher z fzf edc/bass omf/thefuck
```

从 Gist 安装插件。

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

从本地目录安装插件。

```sh
fisher ~/plugin
```

使用 [vundle](https://github.com/VundleVim/Vundle.vim) 的方式安装插件，编辑你的 fishfile 并运行 `fisher` 去安装插件。

> [什么是 fishfile 以及如何使用它?](#6-什么是-fishfile-以及如何使用它)

```sh
$EDITOR fishfile
fisher
```

查看以安装的插件。

```ApacheConf
fisher ls
@ plugin      # 该插件是一个本地插件
* sol         # 该插件是当前的命令行提示符插件
  bass
  fzf
  grc
  thefuck
  z
```

列出远程插件。
```
fisher ls-remote
```

更新所有插件。

```
fisher up
```

更新指定的插件。

```
fisher up bass z fzf thefuck
```

移除指定的插件。

```
fisher rm thefuck
```

移除所有的插件。

```
fisher ls | fisher rm
```

查看插件帮助。

```
fisher help z
```

卸载 fisherman
```
fisher self-uninstall
```

## 常见疑问解答

### fish 的版本要求多少？

fisherman 要求 2.3.0 及以上版本的 fish。如果正在使用 2.2.0 版本，你可以写入以下[代码片段](#8-什么是一个插件)到你的 `~/.config/fish/config.fish`。

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### fisherman 兼容已有的 fish 主题和插件吗？

是的。

### fisherman 把数据放到哪里了？

fisherman 的位置在 *~/.config/fish/functions/fisher.fish*。
缓存和插件配置被分别存在 *~/.cache/fisherman* 和 *~/.config/fisherman*。
fishfile 位置在 *~/.config/fish/fishfile*。

### 什么是 fishfile 以及如何使用它？

fishfile *~/.config/fish/fishfile* 列出了所有已安装的插件。

fisherman 安装插件时，会自动写入这个文件，或者你可以手动写入你想装的插件，然后运行 `fisher` 来安装插件

```
fisherman/sol 
fisherman/z
omf/thefuck
omf/grc
```

这个文件只会记录插件和一些依赖。如果你想卸载插件，可以使用 `fisher rm`来替代。

### 什么是一个插件？

一个插件是：

1. 一个目录或者一个在项目根目录有 *.fish* 文件或者 *functions* 目录的git仓库

2. 一个主题或者命令行提示符，比如 `fish-prompt.fish`, *fish_right_prompt.fish*。

3. 一些代码片段，比如一个或多个在 *conf.d*目录下的 *.fish* 文件，并且它们会在 shell 启动时执行。

### 如何把这些插件作为我自己插件的依赖？

在项目的顶层目录创建一个新的 *fishfile* 文件，并写下你的依赖。

```fish
owner/repo
https://github.com/owner/repo
https://gist.github.com/owner/c256586044fea832e62f02bc6f6daf32
```
