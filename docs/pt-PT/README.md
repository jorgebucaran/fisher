[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://fisherman-wharf.herokuapp.com/badge.svg
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg

[organização]: https://github.com/fisherman
[fish-shell]: https://github.com/fish-shell/fish-shell
[fisherman]: http://fisherman.sh
[online]: http://fisherman.sh/#search

[![Build Status][travis-badge]][travis-link]
[![Slack][slack-badge]][slack-link]

# [fisherman] - fish plugin manager

fisherman é um gestor de plugins para [fish-shell].

## Funcionalidades

* Não necessita de configuração

* Sem dependências externas

* Não tem impacto no arranque da consola

* É possível usar de maneira interactiva ou usando o ficheiro fishfile

* Instala e actualiza plugins concurrentemente

* Apenas o essencial, install, update, remove, list e help

## Instalação

Via curl.

```sh
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman
```

## Uso

Instalar um plugin.

```
fisher simple
```

Instalar através de  múltiplas fontes.

```
fisher z fzf omf/{grc,thefuck}
```

Instalar através de URLs.

```
fisher https://github.com/edc/bass
```

Instalar através de gists.

```
fisher https://gist.github.com/username/1f40e1c6e0551b2666b2
```

Instalar através de uma pasta local.

```sh
fisher ~/my_aliases
```

Edite o ficheiro fishfile e execute `fisher` para aplicar as alterações

> [O que é o ficheiro fishfile e como é que eu o utilizo?](#6-o-que-é-o-ficheiro-fishfile-e-como-é-que-eu-o-utilizo)

```sh
$EDITOR fishfile # adicionar plugins
fisher
```

Mostrar os plugins instalados actualmente.

```ApacheConf
fisher ls
@ my_aliases    # este plugin é uma pasta local
* simple        # este plugin é o Tema da consola
  bass
  fzf
  grc
  thefuck
  z
```

Mostrar os plugins disponíveis para instalação.

```ApacheConf
fisher ls-remote
  ...
  spin          roach       git_util        pwd_info
  submit        flash       pyenv           host_info
  ...
```

Actualizar fihserman e todos os plugins.

```
fisher up
```

Actualizar plugins específicos.

```
fisher up bass z fzf thefuck
```

Remover plugins.

```
fisher rm simple
```

Remover todos os plugins instalados.

```
fisher ls | fisher rm
```

Mostrar ajuda.

```
fisher help z
```

## FAQ

### 1. Qual é a versão da fish necessária?

fisherman foi desenhado para fish >= 2.3.0. Se está a usar a versão 2.2.0, é necessário adicionar o seguinte código no seu ficheiro `~/.config/fish/config.fish` de formar a suportar [snippets](#8-o-que-é-um-plugin).

```fish
for file in ~/.config/fish/conf.d/*.fish
    source $file
end
```

### 2. Como faço para tornar fish a minha consola predefinida?

Adicione fish à lista de consolas no ficheiro */etc/shells* e defina-a como a sua consola por omissão usando os seguintes comandos.

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```

### 3. Como faço para desinstalar fisherman?
```fish
fisher self-uninstall
```

### 4. O fisherman é compatível com os plugins e temas do oh my fish?

Sim.

### 5. Onde é que o fisherman guarda as suas coisas?

O fisherman é guardado no ficheiro *~/.config/fish/functions/fisher.fish*.

A cache e a configuração é guardada nos ficheiros *~/.cache/fisherman* e *~/.config/fisherman* respectivamente.

O ficheiro fishfile é guardado em *~/.config/fish/fishfile*.

### 6. O que é o ficheiro fishfile e como é que eu o utilizo?

O ficheiro fishfile *~/.config/fish/fishfile* contém todos os plugins instalados.

Pode deixar que fisherman tome conta deste ficheiro automaticamente, ou se quiser, pode adicionar os plugins manualmente ao ficheiro e no fim executar `fisher` para aplicar as alterações.

```
fisherman/simple
fisherman/z
omf/thefuck
omf/grc
```

Este comando apenas instalas plugins e suas dependências. Para desinstalar um plugin, tem que executar `fisher rm <nome-do-plugin>`.

### 7. Onde consigo ver os plugins disponíveis para instalação?

Visite a [organização] ou use a pesquisa [online] para descobrir os plugins disponíveis.

### 8. O que é um plugin?

Um plugin é:

1. uma pasta local ou repositório git com uma função dentro de um ficheiro *.fish* na raiz da pasta ou repositório ou dentro de uma pasta chamada *functions*.

2. um tema ou um prompt, i.e, *fish_prompt.fish*, *fish_right_prompt.fish* ou ambos.

3. um snippet, i.e, um ou mais ficheiros *.fish* dentro de uma pasta chamada *conf.d* que são executados sempre por fish no arranque da consola.

### 9. Como posso definir plugins como dependências do meu plugin?

Crie um ficheiro *fishfile* na raiz do seu projecto e adicione ao ficheiros as dependências.

```fish
owner/repo
https://github.com/owner/repo
https://gist.github.com/owner/c256586044fea832e62f02bc6f6daf32
```
