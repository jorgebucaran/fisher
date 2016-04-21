[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

##为什么使用fisherman？

* 简单

* 零配置

* 零依赖

* 不影响 shell 启动速度

* 类似 [vundle](https://github.com/VundleVim/Vundle.vim) 的交互下载功能

* 实现了最核心的功能: 安装、更新、移除和查询插件

## 安装

拷贝 `fisher.fish` 到你的 `~/.config/fish/functions` 目录, 就这么简单。

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
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

使用 vundle(https://github.com/VundleVim/Vundle.vim) 的方式安装插件，编辑你的 fishfile 并运行 `fisher` 去安装插件。

> [什么是 fisherfile 以及如何使用它?](#9-什么是-fishfile-以及如何使用它)

```sh
$EDITOR fishfile # add plugins
fisher
```

查看以安装的插件。

```
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

fisherman 要求 2.2.0 及以上版本的 fish。如果你不能更新你的 fish 版本，你可以写入以下[代码片段](#12-什么是一个插件)到你的 `~/.config/fish/config.fish`。

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. 如何从 OS X 安装 fish?

使用 Homebrew。

```
brew install fish
```

### 3. 如何从一些 linux 发行版安装最近版本的 fish?

使用 git 或者上游源。

```sh
sudo apt-get -y install git gettext automake autoconf \
    ncurses-dev build-essential libncurses5-dev

git clone -q --depth 1 https://github.com/fish-shell/fish-shell
cd fish-shell
autoreconf && ./configure
make && sudo make install
```

### 4. 如何让 fish 作为我默认的 shell ?

Add fish to the list of login shells in `/etc/shells` and make it your default shell.
把 fish 加入到 `/etc/shells` 并令 fish 成为默认 shell。

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 5. 如何卸载 fisherman？

运行以下命令。

```fish
fisher self-uninstall
```

### 6. fisherman 兼容已有的 fish 主题和插件吗？

是的。

### 7. 为什么选择 fisherman？

fisherman 有以下特色：

* 小巧，所有代码都在一个文件

* 不影响 shell 启动速度

* 容易安装、更新和卸载

* 你不再需要配置你的 fish 配置

* 符合 [XDG](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) 规范

### 8. fisherman 把数据放到哪里了？

fisherman 的位置在 `~/.config/fish/functions/fisher.fish`。
缓存和插件配置被分别存在 `~/.cache/fisherman` 和 `~/.config/fisherman`。
fishfile 位置在 `~/.config/fish/fishfile`。

### 9. 什么是 fishfile 以及如何使用它？

fishfile `~/.config/fish/fishfile` 列出了所有已安装的插件。

fisherman 安装插件时，会自动写入这个文件，或者你可以手动写入你想装的插件，然后运行 `fisher` 来安装插件

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

这个文件只会记录插件和一些依赖。如果你想卸载插件，可以使用 `fisher rm`来替代。

### 10. 去哪里可以找到插件？

看看这个 [organization] 或者使用这个 [online] 来搜索。

### 11. 如何从 ____ 更新？

fisherman 没有引入其他任何已知的框架。如果你想卸载 oh my fish, 看它的文档即可

### 12. 什么是一个插件？

一个插件是：

1. 一个目录或者一个在项目根目录有 `.fish` 文件或者 `functions` 目录的git仓库

2. 一个主题或者命令行提示符，比如 `fish-prompt.fish`, `fish_right_prompt.fish`。

3. 一些代码片段，比如一个或多个在 `conf.d`目录下的 `.fish` 文件并且它们会在 shell 启动时执行。

### 13. 如何把这些插件作为我自己插件的依赖？

在项目的顶层目录创建一个新的 `fishfile` 文件，并写下你的依赖。

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```

### 14. 什么是 fundle?

fundle 启发我去使用打包的文件，但是目前它仍然有着一些功能限制，需要你去调整 fish 配置。

### 15. 我有一些问题想提交？

在 gituhb issue 上创建一个新的工单：

* https://github.com/fisherman/fisherman/issues


[fisherman]: http://fisherman.sh
[fish shell]: https://github.com/fish-shell/fish-shell
[organization]: https://github.com/fisherman
[online]: http://fisherman.sh/#search

[English]: ../../README.md
[Español]: ../es-ES
[日本語]: ../jp-JA
