<p align="center">
  <a href="../../README.md">English</a> &bull;
  <b>简体中文</b>
</p>

<a name="fisherman"></a>
[![play]][play-link]
<h4 align="center">
    <br>
    <br>
    <a href="http://fisherman.sh"><img
        alt="fisherman"
        width=800px
        src="https://rawgit.com/fisherman/logo/master/fisherman-black-white.svg"></a>
    <br>
    <br>
    <br>
</h4>

[![Build Status][travis-badge]][travis-link]
[![fisherman Version][version-badge]][version-link]
[![Slack Room][slack-badge]][slack-link]

## 安装

```fish
curl -sL get.fisherman.sh | fish
```

## 使用

安装 [fishery][fishery] 插件。

```
fisher i fishtape shark get bobthefish
```

安装 [Oh My Fish][Oh My Fish] 插件。

```fish
fisher i omf/plugin-{percol,jump,fasd}
```

安装本地插件。

```fish
fisher i ./path/to/plugin
```

从不同的 URL 安装插件。

```fish
fisher i https://github.com/some/plugin another/plugin bb:one/more
```

从 [Gist][Gist] 安装插件。

```fish
fisher i gist.github.com/owner/1f40e1c6e0551b2666b2
```

更新所有的插件。

```
fisher u
```

更新指定的插件。

```
fisher u shark get
```

卸载指定的插件。

```
fisher uninstall fishtape debug
```


## 显示和搜索

`fisher list` 命令会显示本地安装的插件。`fisher search` 命令会通过本地索引去查找合适的插件。

```
fisher list
  debug
  fishtape
  spin
> superman
@ wipe
```

查找插件。

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

使用正则表达式查找插件。

```
fisher search --name~/git-is/
git-is-dirty       Test if there are changes not staged for commit
git-is-empty       Test if a repository is empty
git-is-repo        Test if the current directory is a Git repo
git-is-staged      Test if there are changes staged for commit
git-is-stashed     Test if there are changes in the stash
git-is-touched     Test if there are changes in the working tree
```

使用标签查找插件。

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

最前面的符号有以下几种含义:

* `>` 该插件是用于修改提示符
* `*` 该插件已安装
* `@` 该插件是一个本地软链接


## 管道

fisherman 的命令全部支持管道。可以通过管道来连接其他命令，从而实现更复杂的功能。

更新所有为软链接的插件。

```fish
fisher list --link | fisher update -
```

重新启用被禁用的插件。

```fish
fisher list --disabled | fisher install
```

卸载所有的插件，并从缓存中删除。

```fish
fisher list | fisher uninstall --force
```

## Dotfiles

当你安装插件时，fisherman 会更新到 *fishfile* 以便之后跟踪启用了哪些插件。

* 自定义 *fishfile* 的位置。

```fish
set -g fisher_file ~/.dotfiles/fishfile
```

## 扁平的目录结构

fisherman 会合并所有插件的目录到一个扁平的目录结构。之所以这样做的原因是因为无论安装了多少插件，只用在 shell 启动时加载一次，fisherman 就能拥有不错的性能。   

以下图例展现了一个插件在 Fiserhman 中的目录结构。
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

## 索引

索引就是一个用来记录被 fisherman 安装的插件的文本数据库。

索引记录了每个插件的*名字*， *地址*， *信息*，*标签*以及*作者*。

```
z
https://github.com/fishery/z
Pure-fish z directory jumping
z search cd jump
jethrokuan
```

如果你想要提交插件， 你可以向这个 [仓库](https://github.com/fisherman/index) 发起一个 PR
```
git clone https://github.com/fisherman/index
cd index
echo "$name\n$url\n$info\n$tags\n$author\n\n" >> index
git push origin master
```

## 变量

* $fisher_home:
    fisherman 的家目录。如果你按照推荐的方式安装了 fisherman，这个变量应该是 *XDG_DATA_HOME/fisherman* 。

* $fisher_config:
    fisherman 的配置目录。这个目录默认应该是你的 *fishfile*, *key_bindings.fish*, *cache*, *functions*, *completions* and *conf.d* 等目录所在的位置。它的默认值是 *XDG_CONFIG_HOME/fisherman* 。

* $fisher_file:
    具体查看 [fishfile](#dotfiles) 。

* $fisher_cache:
    fisherman 的缓存目录。 所有的插件都会被下载到这个位置。

* $fisher_alias *command*=*alias* ...:
    可以使用这个变量去创建 fisherman 的命令别名。

[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square

[version-badge]: https://img.shields.io/badge/latest-v1.4.0-00B9FF.svg?style=flat-square
[version-link]: https://github.com/fisherman/fisherman/releases

[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square

[play]: https://cloud.githubusercontent.com/assets/8317250/14401577/14411b12-fe51-11e5-8d5a-bb054edfc2d4.png
[play-link]: http://fisherman.sh/#demo

[Get Started]: https://github.com/fisherman/fisherman/wiki
[Plugins]: http://fisherman.sh/#search
[fish]: https://github.com/fish-shell/fish-shell

[other]: https://github.com/fisherman/fisherman/wiki/Installing-fisherman#notes
[fisherman]: http://fisherman.sh
[new]: https://github.com/fishery/new

[fishery]: https://github.com/fishery
[Oh My Fish]: https://github.com/oh-my-fish
[Gist]: https://gist.github.com/
