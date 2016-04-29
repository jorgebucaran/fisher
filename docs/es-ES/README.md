[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organización]: https://github.com/fisherman
[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[en línea]: http://fisherman.sh/#search

[English]: ../../README.md
[简体中文]: ../zh-CN
[日本語]: ../jp-JA
[Русский]: ../ru-RU
[한국어]: ../ko-KR
[Català]: ../ca-ES

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish plugin manager

Lee este documento en otro idioma: [English], [日本語], [简体中文], [한국어], [Русский], [Català].

## Prestaciones

* Sin configuración

* Sin dependencias externas

* No afecta al tiempo de inicio de la sesión

* Se puede utilizar de manera interactiva o con un archivo fishfile

* Instala i actualiza paquetes de manera concurrente

* Solo lo fundamental, install, update, remove, list y help

## Instalación

Via curl.

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

## Modo de uso

Instalar paquetes.

```
fisher simple
```

Instalar desde múltiples fuentes.

```
fisher z fzf omf/{grc,thefuck}
```

Instalar desde URLs.

```
fisher https://github.com/edc/bass
```

Instalar desde gists.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Instalar desde un directorio.

```sh
fisher ~/my_aliases
```

Edita el archivo fishfile y ejecuta `fisher` para aplicar los cambios.

> [¿Qué es el archivo fishfile y cómo lo utilizo?](#6-qué-es-el-fishfile-y-cómo-lo-uso)

```sh
$EDITOR fishfile # añade los paquetes como dependencias
fisher
```

Muestra que tienes instalado actualmente.

```ApacheConf
fisher ls
@ my_aliases    # este paquete esta en un directorio
* simple        # este paquete es el tema actual
  bass
  fzf
  grc
  thefuck
  z
```

Busca que puedes llegar a instalar.

```ApacheConf
fisher ls-remote
  ...
  spin          roach       git_util        pwd_info
  submit        flash       pyenv           host_info
  ...
```

Actualizalo todo.

```
fisher up
```

Actualiza algunos paquetes.

```
fisher up bass z fzf thefuck
```

Elimina paquetes.

```
fisher rm simple
```

Elimina todos los paquetes.

```
fisher ls | fisher rm
```

Muestra ayuda.

```
fisher help z
```

## FAQ

### 1. ¿Qué versión de fish es necesaria?

fisherman fue diseñado para fish >= 2.3.0. Si tienes la versión 2.2.0 y no puedes actualizarla por algún motivo, añade este código en el archivo `~/.config/fish/config.fish` para poder ejecutar [snippets](#8-qué-es-un-paquete).

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. ¿Cómo hago fish mi consola de comandos por defecto?

Añade fish a la lista de consolas de comandos en `/etc/shells`.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 3. ¿Cómo puedo desinstalar fisherman?

Ejecuta

```fish
fisher self-uninstall
```

o

```fish
npm un -g fisherman
```

### 4. ¿Es fisherman compatible con paquetes y temas de oh my fish?

Sí.

### 5. ¿Dónde guarda fisherman sus cosas?

fisherman mismo esta en el archivo `~/.config/fish/functions/fisher.fish`.

El caché y la configuración en `~/.cache/fisherman` y `~/.config/fisherman` respectivamente.

El archivo fishfile en `~/.config/fish/fishfile`.

### 6. ¿Qué es el archivo fishfile y cómo lo uso?

El archivo fishfile `~/.config/fish/fishfile` contiene todos los paquetes que están instalados.

Puedes dejar que fisherman se encargue de este archivo automáticamente, o incluir los paquetes que necesitas y ejecutar `fisher` para aplicar los cambios.

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

Este comando solo instala paquetes y sus dependencias. Para borrar paquetes, usa `fisher rm`.

### 7. ¿Dónde consigo un listado de paquetes para fish?

Dirígete a la [organización] o usa la búsqueda [en línea] para descubrir contenido.

### 8. ¿Qué es un paquete?

Un paquete es:

1. un directorio o repositorio de git con una función / archivo `.fish` bien sea en el directorio raíz del proyecto o en un directorio llamado `functions`.

2. un tema o prompt, es decir, `fish_prompt.fish`, `fish_right_prompt.fish` o ambos.

3. un snippet, es decir, uno o más archivos `.fish` en un directorio llamado `conf.d` que son ejecutados por fish al iniciar la sesión.

### 9. ¿Cómo puedo añadir dependencias a mi plugin?

Crea un archivo `fishfile` en la carpeta raíz de tu plugin y incluye los paquetes en el.

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```
