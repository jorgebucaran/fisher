[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square

[organization]: https://github.com/fisherman
[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[ウェブサイト]: http://fisherman.sh/#search

[English]: ../../README.md
[Español]: ../es-ES
[简体中文]: ../zh-CN
[Русский]: ..//ru-RU

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

fishermanとは、フィッシュシェルのための並列処理パッケージマネージャーである。

翻訳: [English], [Español], [简体中文], [Русский].

## 理由

* 簡単

* 設定なし

* 依存性なし

* フィッシュシェルのスタート時間に関係ない

* cliから利用可能であり、vundleのようにも使える

* 基本のコマンド、install、update、remove、listとhelpだけである

## インストール

curlで。

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

npmで。

```
npm i -g fisherman
```

## 使い方

プラグインをインストール。

```
fisher simple
```

様々な所からもインストール。

```
fisher z fzf omf/{grc,thefuck}
```

URLからインストール。

```
fisher https://github.com/edc/bass
```

Gistをインストール。

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

ディレクトリをインストール。

```sh
fisher ~/my_aliases
```

vundleのように、「fishfile」というファイルに、プラグインたちを打って、`fisher`を入力すると、インストールされる。

> [fishfileとは？](#6-fishfileとは)

```sh
$EDITOR fishfile # プラグインを入れる
fisher
```

インストールされるプラグインを表示する。

```
fisher ls
@ my_aliases    # este paquete es un directorio
* simple        # este paquete es el tema actual
  bass
  fzf
  grc
  thefuck
  z
```

全部をアップデート。

```
fisher up
```

いくつかのプラグインをアップデート。

```
fisher up bass z fzf thefuck
```

プラグインを削除。

```
fisher rm simple
```

全部のプラグインを削除。

```
fisher ls | fisher rm
```

ドキュを表示。

```
fisher help z
```

## FAQ

### 1. fishの必要なバージョンとは？

fish >= 2.3.0は必要です。まだ2.2.0を利用中であれば、[snippets](#8-プラグインとは)の対応のため、次のコードを`~/.config/fish/config.fish`に書いてください。

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. フィッシュシェルをデフォルトのシェルにするには？

システムの`/etc/shells`ファイルに、fishを追加して下さい。

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 3. fishermanを削除する方法とは？

```fish
fisher self-uninstall
```

もしくは

```fish
npm un -g fisherman
```

### 4. oh-my-fishのプラグインとテーマに対応ですか？

対応です。

### 5. fishermanのファイル等は、どこに保存されますか？

fisherman自体は`~/.config/fish/functions/fisher.fish`に。

キャシュは`~/.cache/fisherman`に、コンフィグディレクトリは`~/.config/fisherman`に。

fishfileは`~/.config/fish/fishfile`に。

### 6. fishfileとは？

fishfile（`~/.config/fish/fishfile`）に現在インストールされているプラグインを記入してあります。


fishermanに任せて、このファイルを自動的に扱って頂けるか、自分で手に入れたいプラグインを入れて、`fisher`を入力すると、インストールも可能です。

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

この仕組はプラグインと、そのプラグインのデペンデンシーをインストールすることができます。プラグインを削除するために、`fisher rm`を使ってください。

### 7. フィッシュシェルのプラグインはどこにありますか？

fishermanの[organization]や、[ウェブサイト]等で、プラグインを検索できます。

### 8. プラグインとは？

プラグインとは

1. 普通のディレクトリや、gitレポジトリのrootに、`.fish`ファイルの関数、それか、`functions`ディレクトリに。

2. テーマ。つまり、`fish_prompt.fish`か`fish_right_prompt.fish`か両方。

3. スニペット。つまり、1以上の`.fish`ファイルを`conf.d`といディレクトリに。こちらのファイルがフィッシュシェルがスタートする際に実行されます。

### 9. 自分のプラグインを、他のプラグインのデペンデンシーにしたい場合は？

プラグインのrootディレクトリに`fishfile`編集して、そのプラグインを打ってください。

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```

### 10. fundleはどう？

fundleを参考しながら、vundleのようにfishfileを使いたいと思いましたが、fundle自体はまだ特徴はすくないですし、フィッシュシェルの設定をいじることは必要です。
