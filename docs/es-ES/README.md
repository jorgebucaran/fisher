[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square

[organización]: https://github.com/fisherman
[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[en línea]: http://fisherman.sh/#search

[English]: ../../README.md
[简体中文]: ../zh-CN
[日本語]: ../jp-JA

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

fisherman es un gestionador de paquetes para el [fish shell] de procesamiento en paralelo.

Lee este documento en otro idioma: [English], [日本語], [简体中文].

## Motivo

* Simple

* Sin configuración

* Sin dependencias externas

* No influye en el tiempo de inicio de la sesión

* Se puede utilizar de manera interactiva o _a la_ vundle

* Solo lo fundamental, install, update, remove, list y help

## Instalación

Copia `fisher.fish` en `~/.config/fish/functions` y listo.

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

## Uso

Instala paquetes.

```
fisher simple
```

Instala de múltiples fuentes.

```
fisher z fzf omf/{grc,thefuck}
```

Instala URLs.

```
fisher https://github.com/edc/bass
```

Instala gists.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Instala un directorio.

```sh
fisher ~/my_aliases
```

A la vundle. Edita el fishfile y entra `fisher` para satisfacer los cambios.

> [¿Qué es el fishfile y cómo lo utilizo?](#7-qué-es-el-fishfile-y-cómo-lo-uso)

```sh
$EDITOR fishfile # añade paquetes
fisher
```

Muestra que está instalado actualmente.

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

### 1. ¿Qué versión de fish se requiere?

fisherman fue diseñado para fish >= 2.3.0. Si estás en 2.2.0 y no puedes actualizarte por algún motivo, añade este código a `~/.config/fish/config.fish` para poder ejecutar [snippets](#10-qué-es-un-paquete).

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. ¿Cómo hago fish mi shell por defecto?

Añade fish a la lista de login shells in `/etc/shells`.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 3. ¿Cómo puedo desinstalar fisherman?

Entra

```fish
fisher self-uninstall
```

### 4. ¿Es fisherman compatible con paquetes y temas de oh my fish?

Sí.

### 5. ¿Por qué fisherman? ¿Por qué no ____?

fisherman tiene / es:

* Diminuto y cabe en un solo archivo

* No influye en el tiempo de inicio de la sesión

* Rápido y fácil de instalar, actualizar y desinstalar

* No requiere modificar tu configuración de fish

* Usa el sistema XDG de directions base correctamente

### 6. ¿Dónde guarda fisherman las cosas?

fisherman mismo va en `~/.config/fish/functions/fisher.fish`.

El caché y la configuración en `~/.cache/fisherman` y `~/.config/fisherman` respectivamente.

El fishfile en `~/.config/fish/fishfile`.

### 7. ¿Qué es el fishfile y cómo lo uso?

El fishfile `~/.config/fish/fishfile` registra todos los paquetes que están instalados.

Puedes dejar que fisherman se encargue de este archivo automáticamente, o ingresar los paquetes que requieres y entrar `fisher` para satisfacer los cambios.

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

Este mecanismo solo instala paquetes y dependecias necesarias. Para remover paquetes, usa `fisher rm`.

### 8. ¿Dónde consigo las lista de paquetes para fish?

Diríjete a la [organización] o usa la búsqueda [en línea] para descrubir contenido.

### 9. ¿Cómo puedo migrar desde ____?

fisherman no interfiere con otros sistemas conocidos. Si quieres desinstalar oh my fish, diríjete a su documentación

### 10. ¿Qué es un paquete?

Un paquete es:

1. un directorio o repositorio de git con una función / archivo `.fish` bien sea en el nivel raíz del proyecto o en un directorio llamado `functions`.

2. un tema o prompt, es decir, `fish_prompt.fish`, `fish_right_prompt.fish` o ambos.

3. un snippet, es decir, uno o más archivos `.fish` en un directorio llamado `conf.d` que son ejecutados por fish al inicio de la sesión.

### 11. ¿Cómo puedo añadir dependencias a mi plugin?

Crea un `fishfile` en el nivel raíz de tu proyecto y escribe los paquetes.

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```

### 12. ¿Qué puedes decir de fundle?

fundle fue la inspiración para utilizar el fishfile, pero todavía es limitado en sus capacidades y hace requisito modificar la configuración de fish.

### 13. Tengo una pregunta que no aparece aquí. ¿Dónde pregunto?

Crea un nuevo ticket en el issue tracker:

* https://github.com/fisherman/fisherman/issues
