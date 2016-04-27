[slack-link]: https://fisherman-wharf.herokuapp.com
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organització]: https://github.com/fisherman
[fish shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[en línia]: http://fisherman.sh/#search

[English]: ../../README.md
[Español]: docs/es-ES
[简体中文]: docs/zh-CN
[日本語]: docs/jp-JA
[한국어]: docs/ko-KR
[Русский]: docs/ru-RU
[Català]: docs/ca-ES

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish shell plugin manager

fisherman es un gestor de complements concurrent per a la consola de comandes [fish shell].

Llegeix aquest document en un altre llenguatge: [English], [Español], [日本語], [简体中文], [한국어], [Русский].

## Per que?

* Sense configuració

* Sense dependencies externes

* No afecta als temps d'arrencada de la consola de comandes

* Fes-la anar interactivament o _a la_ vundle

* Només l'essencial, instal·lar, actualitzar, esborrar, llistar i ajuda

## Instal·la

Amb curl.

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

Amb npm.

```
npm i -g fisherman
```

Si encara estàs fent anar la versió 1.5 i vols actualitzar a >2.0 sense mes preocupació.

```
curl -L git.io/fisher-up-me | fish
```

## Mode d'ús

Instal·la un complement.

```
fisher simple
```

Instal·la des de múltiples fonts.

```
fisher z fzf omf/{grc,thefuck}
```

Instal·la des de una URL.

```
fisher https://github.com/edc/bass
```

Instal·la des de un gist.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Instal·la des de un directori local.

```sh
fisher ~/my_aliases
```

Fes-lo anar a la vundle. Edita el teu arxiu fishfile i executa `fisher` per a aplicar els canvis.

> [Que és un arxiu fishfile i com el faig anar?](#6-que-és-un-arxiu-fishfile-i-com-el-faig-anar)

```sh
$EDITOR fishfile # afegeix complements
fisher
```

Fes un cop d'ull al que tens instal·lat.

```ApacheConf
fisher ls
@ my_aliases    # aquest complement esta dins un directori local
* simple        # aquest complement es el tema actual
  bass
  fzf
  grc
  thefuck
  z
```

Actualitza-ho tot.

```
fisher up
```

Actualitza alguns complements.

```
fisher up bass z fzf thefuck
```

Esborra alguns complements.

```
fisher rm simple
```

Esborra tots els complements.

```
fisher ls | fisher rm
```

Aconsegueix ajuda.

```
fisher help z
```

## FAQ

### 1. Quina es la versió necessaria de fish?

fisherman va ésser construït per a fish >= 2.3.0. Si estàs fent anar la versió 2.2.0,
afegeix el següent codi al teu arxiu `~/.config/fish/config.fish` per a donar suport a [retalls](#8-que-es-un-complement).

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. Com converteixo fish en la meva consola de comandes per defecte?

Afegeix fish a la llista de consoles de comandes dins de l'arxiu `/etc/shells` i converteix-la en la teva consola de comandes per defecte.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 3. Com des-instal·lo fisherman?

```fish
fisher self-uninstall
```

o

```
npm un -g fisherman
```

### 4. És fisherman compatible amb els temes i complements de oh my fish?

Si.

### 5. On deixa fisherman les seves coses?

fisherman es guarda al directori `~/.config/fish/functions/fisher.fish`.

La caché i configuracions són creades dins de `~/.cache/fisherman` i `~/.config/fisherman` respectivament.

El arxiu fishfile es guarda a `~/.config/fish/fishfile`.

### 6. Que és un arxiu fishfile i com el faig anar?

El arxiu fishfile `~/.config/fish/fishfile` llista tots els complements instal·lats.

Pots deixar que en fisherman s'encarregui d'aquest arxiu per tu automaticament, o be escriure a dins els complements que vols instal·lar i llavors executar `fisher` per a aplicar els canvis.

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

Aquest procediment només instal·la complements i dependències. Per esborrar complements, fes anar `fisher rm` al seu lloc.

### 7. On puc trobar una llista de complements de fish?

Busca dins de l'[organització] o fes anar la busqueda [en línia] per descobrir contingut.

### 8. Que es un complement?

Un complement es:

1. un directori o repositori de git amb una funció dins d'un arxiu `.fish` ja be a l'arrel del projecte o dins d'un directori `functions`

2. un tema o prompt, p.e., un `fish_prompt.fish`, `fish_right_prompt.fish` o ambdós

3. un retall, p.e., un o mes arxius `.fish` dins un directori anomenat `conf.d` que es evaluat per fish a l'arrencada de la consola de comandes.

### 9. Com puc llistar complements com dependencies del meu complement?

Crea un nou arxiu `fishfile` a l'arrel del teu i escriu a dins les dependències del teu complement.

```fish
owner/repo
https://github.com/dude/sweet
https://gist.github.com/bucaran/c256586044fea832e62f02bc6f6daf32
```
