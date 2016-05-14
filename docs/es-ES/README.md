[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organización]: https://github.com/fisherman
[fish]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[en línea]: http://fisherman.sh/#search

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman]

fisherman es un gestor de paquetes para [fish].

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
fisher real
```

Instalar desde múltiples fuentes.

```
fisher z fzf edc/bass omf/thefuck
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
fisher ~/plugin
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
@ plugin    # este paquete esta en un directorio
* real        # este paquete es el tema actual
  bass
  fzf
  grc
  thefuck
  z
```

Muestra que puedes instalar.

```
fisher ls-remote
```

Actualiza todo.

```
fisher up
```

Actualiza algunos paquetes.

```
fisher up bass z fzf thefuck
```

Elimina paquetes.

```
fisher rm thefuck
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

### ¿Qué versión de fish es necesaria?

fisherman fue diseñado para fish >= 2.3.0. Si tienes la versión 2.2.0 y no puedes actualizarla por algún motivo, añade este código en el archivo `~/.config/fish/config.fish` para poder ejecutar [snippets](#8-qué-es-un-paquete).

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### ¿Cómo hago fish mi consola de comandos por defecto?

Añade fish a la lista de consolas de comandos en */etc/shells*.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### ¿Cómo puedo desinstalar fisherman?

Ejecuta

```fish
fisher self-uninstall
```

o

```fish
npm un -g fisherman
```

### ¿Es fisherman compatible con paquetes y temas de oh my fish?

Sí.

### ¿Dónde guarda fisherman sus cosas?

fisherman mismo esta en el archivo *~/.config/fish/functions/fisher.fish*.

El caché y la configuración en *~/.cache/fisherman* y *~/.config/fisherman* respectivamente.

El archivo fishfile en *~/.config/fish/fishfile*.

### ¿Qué es el archivo fishfile y cómo lo uso?

El archivo fishfile *~/.config/fish/fishfile* contiene todos los paquetes que están instalados.

Puedes dejar que fisherman se encargue de este archivo automáticamente, o incluir los paquetes que necesitas y ejecutar `fisher` para aplicar los cambios.

```
fisherman/real
fisherman/z
omf/thefuck
omf/grc
```

Este comando solo instala paquetes y sus dependencias. Para borrar paquetes, usa `fisher rm`.

### ¿Dónde consigo un listado de paquetes para fish?

Dirígete a la [organización] o usa la búsqueda [en línea] para descubrir contenido.

### ¿Qué es un paquete?

Un paquete es:

1. un directorio o repositorio de git con una función / archivo *.fish* bien sea en el directorio raíz del proyecto o en un directorio llamado *functions*.

2. un tema o prompt, es decir, *fish_prompt.fish*, *fish_right_prompt.fish* o ambos.

3. un snippet, es decir, uno o más archivos *.fish* en un directorio llamado *conf.d* que son ejecutados por fish al iniciar la sesión.

### ¿Cómo puedo añadir dependencias a mi plugin?

Crea un archivo *fishfile* en la carpeta raíz de tu plugin y incluye los paquetes en el.

```fish
owner/repo
https://github.com/owner/repo
https://gist.github.com/owner/c256586044fea832e62f02bc6f6daf32
```
