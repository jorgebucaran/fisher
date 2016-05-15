[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[fish]: https://github.com/fish-shell/fish-shell
[fisherman]: https://github.com/fisherman.sh

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman]

Менеджер плагинов для [fish].

## Установка

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

## Использование

Установка отдельного плагина.

```
fisher real
```

Установка из нескольких источников.

```
fisher z fzf edc/bass omf/thefuck
```

Установка из gist.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Установка из локального каталога.

```sh
fisher ~/plugin
```

Отредактируйте [fishfile](#Что-такое-fishfile-и-как-я-могу-его-использовать) и запустите `fisher`, чтобы изменения вступили в силу.

```sh
$EDITOR ~/.config/fish/fishfile
fisher
```

Список установленных плагинов.

```ApacheConf
fisher ls
@ plugin      # локальный плагин
* real        # текущее оформление командной строки
  bass
  fzf
  thefuck
  z
```

Список доступных плагинов.

```
fisher ls-remote
```

Обновление всего сразу.

```
fisher up
```

Обновление отдельных плагинов.

```
fisher up bass z fzf
```

Удаление плагинов.

```
fisher rm thefuck
```

Удаление всех плагинов.

```
fisher ls | fisher rm
```

Справка по плагину.

```
fisher help z
```

Удаление fisherman.

```
fisher self-uninstall
```

## Часто задаваемые вопросы

### Какая версия fish необходима?

\>=2.2.0.

Для поддержки [cниппетов](#Что-такое-плагин) обновите fish до версии >= 2.3.0 или добавьте следующий код в ваш `~/.config/fish/config.fish`:

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### Совместим ли fisherman с темами и плагинами oh my fish?

Да.

### Где fisherman хранит данные?

Кэш и настройки плагинов находятся в *~/.cache/fisherman* и *~/.config/fisherman* соответственно.

fishfile сохраняется в *~/.config/fish/fishfile*.

### Что такое fishfile и как я могу его использовать?

В *~/.config/fish/fishfile* хранится список всех установленных плагинов.

fisherman обновляет этот файл автоматически, но вы также можете добавить плагины в список вручную и запустить `fisher`, чтобы эти изменения вступили в силу.

Этот механизм только устанавливает плагины и отсутствующие зависимости. Чтобы удалить плагин, используйте `fisher rm`.

### Что такое плагин?

Плагином является:

1. каталог или git репозиторий с файлом *.fish* либо на корневом уровне проекта, либо в директории *functions*

2. тема или оформление командной строки, т.е. *fish_prompt.fish*, *fish_right_prompt.fish* или оба файла

3. сниппет, т.е. один или несколько *.fish* файлов в директории *conf.d*, которые загружаются при запуске fish

### Как я могу объявить зависимости моего плагина?

Создайте новый *fishfile* в корне вашего проекта со списком зависимостей.
