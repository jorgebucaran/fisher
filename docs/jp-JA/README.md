[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organization]: https://github.com/fisherman
[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[ウェブサイト]: http://fisherman.sh/#search

[English]: ../../README.md
[Español]: ../es-ES
[简体中文]: ../zh-CN
[Русский]: ..//ru-RU
[한국어]: ../ko-KR
[Català]: ../ca-ES

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

fisherman とは フィッシュシェルのための並列処理パッケージマネージャーです。

翻訳: [English], [Español], [简体中文], [한국어], [Русский], [Català].

## 理由

* 設定なし

* 依存性なし

* フィッシュシェルのスタート時間に関係ない

* cli から利用可能であり、vundle のようにも使える

* 基本のコマンドは install、update、remove、list と help だけ

## インストール

curl:

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

npm:

```
npm i -g fisherman
```

## 使い方

プラグインをインストール:

```
fisher simple
```

様々な所からもインストール:

```
fisher z fzf omf/{grc,thefuck}
```

URL からインストール:

```
fisher https://github.com/edc/bass
```

Gist をインストール:

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

ディレクトリをインストール:

```sh
fisher ~/my_aliases
```

vundleのように 「fishfile」というファイルにプラグインたちを追加して `fisher` でインストール：

> [fishfileとは？](#6-fishfileとは)

```sh
$EDITOR fishfile # プラグイン追加
fisher
```

インストールされるプラグイン表示：

```ApacheConf
fisher ls
@ my_aliases    # este paquete es un directorio
* simple        # este paquete es el tema actual
  bass
  fzf
  grc
  thefuck
  z
```

すべてのプラグインをアップデート：

```
fisher up
```

いくつかのプラグインをアップデート：

```
fisher up bass z fzf thefuck
```

プラグインを削除：

```
fisher rm simple
```

すべてのプラグインを削除：

```
fisher ls | fisher rm
```

ドキュメントを表示：

```
fisher help z
```

## FAQ

### 1. fishの必要なバージョンとは？

fish >= 2.3.0 が必要です。まだ 2.2.0 を使っているのならば [snippets](#8-プラグインとは) の対応のため次のコードを `~/.config/fish/config.fish` に追記してください。

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. フィッシュシェルをデフォルトのシェルにするには？

システムの `/etc/shells` ファイルに、fish を追加:

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

対応してます

### 5. fishermanのファイル等は、どこに保存されますか？

fisherman 自体は `~/.config/fish/functions/fisher.fish` に作成されます。そしてキャシュは`~/.cache/fisherman`に、コンフィグディレクトリは `~/.config/fisherman` に。fishfileは`~/.config/fish/fishfile`に保存されます

### 6. fishfileとは？

fishfile（`~/.config/fish/fishfile`）に現在インストールされているプラグインが書かれています。

fisherman で自動的にこのファイルを更新するか、手動でプラグインを追加して `fisher`を入力してインストールすることも可能です。

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

この仕組はプラグインと、そのプラグインが依存しているものをインストールすることができます。プラグインを削除するために、`fisher rm`を使ってください。

### 7. フィッシュシェルのプラグインはどこにありますか？

fisherman の [organization] や [ウェブサイト] 等で、プラグインを検索できます。

### 8. プラグインとは？

プラグインとは

1. 普通のディレクトリや、gitレポジトリのrootに、`.fish`ファイルの関数、それか、`functions`ディレクトリに。

2. テーマ。つまり、`fish_prompt.fish`か`fish_right_prompt.fish`か両方。

3. スニペット。つまり、1以上の`.fish`ファイルを`conf.d`といディレクトリに。こちらのファイルがフィッシュシェルがスタートする際に実行されます。

### 9. 自分のプラグインを、他のプラグインのデペンデンシーにしたい場合は？

プラグイン root ディレクトリの `fishfile` 編集してそのプラグインを追加してください。

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```
