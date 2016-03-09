[![Build Status][travis-badge]][travis-link]
[![Fisherman Version][version-badge]][version-link]
[![Slack Room][slack-badge]][slack-link]

<a name="fisherman"></a>

<h1 align="center">
    <br>
    <a href="http://fisherman.sh"><img
        alt="Fisherman"
        width=700px
        src="https://rawgit.com/fisherman/logo/master/fisherman-black-white.svg"></a>
    <br>
    <br>
</h1>

**[Fisherman]** is a blazing fast, modern plugin manager for [fish].

```fish
curl -sL get.fisherman.sh | fish
```

[![play]][play-link]

<sub>If you don't have Fish, you need to install it too. Install instructions can be found <a href="https://github.com/fisherman/fisherman/wiki/Installing-Fish">here</a>.</sub>

## Setup

Download Fisherman using Git and setup your system automatically. See [other] install options.

```fish
curl -sL get.fisherman.sh | fish
```

## CLI

The Fisherman CLI consists of the following commands: *install*, *update*, *uninstall*, *list*, *search* and *help*.

Fisherman knows the following aliases: *i* for install, *u* for update, *l* for list, *s* for search and *h* for help.

### Examples

* Install plugins.

```fish
fisher install fishtape shark get
```

* Install a plugin from a local directory.

```fish
fisher install ./path/to/plugin
```

* Install a plugin from a URL.

```fish
fisher install owner/repo
```

* Install a plugin from a Gist URL.

```fish
fisher install gist.github.com/owner/1f40e1c6e0551b2666b2
```

* Update Fisherman.

```fish
fisher update
```

* Update plugins.

```fish
fisher update shark get
```

* Uninstall plugins.

```fish
fisher uninstall fishtape debug
```

* Uninstall plugins and remove them from the cache.

```fish
fisher uninstall fishtape debug -f
```

* Show the documentation.

```fish
fisher help
```

## List and search

The list command displays all the plugins you have installed. The search command queries the index to show what's available to install.

* List installed plugins.

```
fisher list
  debug
* fishtape
> shellder
* spin
@ wipe
```

The legend consists of:

* `*` The plugin is currently enabled
* `>` The plugin is a prompt
* `@` The plugin is a symbolic link


* Search the index.

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
> shellder     Powerline prompt optimized for speed
  ...
```

* Get detailed information about a plugin.

```
fisher search shellder
> shellder by simnalamburt
Powerline prompt optimized for speed
github.com/simnalamburt/shellder
```

* Search plugins using tags.

```
fisher search --tag={git,test}
  ...
* fishtape           TAP producing test runner
  git-branch-name    Get the name of the current Git branch
  git-is-repo        Test if the current directory is a Git repo
  git-is-dirty       Test if there are changes not staged for commit
  git-is-stashed     Test if there are changes in the stash
  ...
```

## Plumbing

Fisherman commands are pipe aware. Plumb one with another to create complex functionality.

* Update all the plugins in the cache.

```fish
fisher list | fisher update -
```

* Enable all the plugins that are currently disabled.

```fish
fisher list --disabled | fisher install
```

* Uninstall all the plugins and remove them from the cache.

```fish
fisher list | fisher uninstall --force
```

## Dotfiles

When you install a plugin, Fisherman updates a file known as *fishfile* to track what plugins are currently enabled.

* Customize the location of the fishfile.

```fish
set -g fisher_file ~/.dotfiles/fishfile
```

## Flat Tree

Fisherman merges the directory trees of all the plugins it installs into a single flat tree. Since the flat tree is loaded only once at the start of the shell, Fisherman performs equally well, regardless of the number of plugins installed.

The following illustrates an example Fisherman configuration path with a single plugin and prompt.

```
$fisher_config
|-- cache/
|-- conf.d/
|   `-- my_plugin.config.fish
|-- fishfile
|-- functions/
|   |-- my_plugin.fish
|   |-- fish_prompt.fish
|   `-- fish_right_prompt.fish
|-- completions/
|   `-- my_plugin.fish
`-- man/
    `-- man1/
        `-- my_plugin.1
```

## Index

The index is a plain text database that lists Fisherman official plugins.

The index is a list of records, each consisting of the following fields: *name*, *url*, *info*, one or more *tags* and *author*.

Fields are separated by a new line `\n`. Tags are separated by one *space*.

```
z
https://github.com/fishery/fish-z
Pure-fish z directory jumping
z search cd jump
jethrokuan
```

If you have a plugin you would like to submit to the index, use the submit plugin.

```
fisher install submit
fisher submit my_plugin
```

Otherwise, submit the plugin manually by creating a pull request in the index repository *https://github.com/fisherman/fisher-index*.

```
git clone https://github.com/fisherman/fisher-index
cd index
echo "$name\n$url\n$info\n$tags\n$author\n\n" >> index
git push origin master
```

## Fishfile

Fisherman keeps track of a special file known as *fishfile* to know what plugins are currently enabled.

```
# My Fishfile
gitio
fishtape
shark
get
shellder
```

This file is automatically updated as you install and uninstall plugins.

## Variables

* $fisher_home<br>
    The home directory. If you installed Fisherman using the recommended method `curl -sL install.fisherman.sh | fish`, the location ought to be *XDG_DATA_HOME/fisherman*. If you clone Fisherman and run make yourself, the current working directory is used by default.

* $fisher_config<br>
    The configuration directory. This is default location of the *fishfile*, *key_bindings.fish*, *cache*, *functions*, *completions* and *conf.d* directories. The default location is *XDG_CONFIG_HOME/fisherman*.

* $fisher_file<br>
    See FISHFILE above.

* $fisher_cache<br>
    The cache directory. Plugins are downloaded to this location.

* $fisher_alias *command*=*alias* ...<br>
    Use this variable to create aliases of Fisherman commands.

## Plugins

Plugins can be utilities, prompts, commands or snippets.

### Utilities

Utilities are plugins that define one or more functions which are mean to be used in the CLI directly by the user.

This example walks you through creating *wtc*, a plugin based in [ngerakines/commitment](https://github/ngerakines/commitment) random commit message generator.

* Create a directory and initialize a Git repository.

```fish
mkdir wtc
cd wtc
git init
git remote add origin https://github.com/<you>/wtc
```

* Add the wtc function.

```fish
function wtc -d "Generate a random commit message"
    switch "$argv"
        case -h --help
            printf "Usage: wtc [--help]\n\n"
            printf "  -h --help  Show usage help\n"
            return
    end
    curl -s whatthecommit.com/index.txt
end
```

* Install the plugin.

```fish
fisher install .
wtc
(\ /)
(O.o)
(> <) Bunny approves these changes.
```

* Commit changes and push to your remote origin when you are done.

```fish
git add --all
git commit -m "What the commit?"
git push origin master
```

### Submit

To submit wtc to the official index.

```fish
fisher install submit
fisher submit
```

This will create a PR in the Fisherman index repository. Once the PR is approved, Fisherman users will be able to install wtc if they have the latest index.

```fish
fisher install wtc
```

See `fisher help submit` for more submit options.

### Completions

Create a completions directory and add a completions file.

```fish
mkdir completions
cat > completions/wtc.fish
complete --command wtc --short h --long help --description "Show usage help"
^
```

Alternatively, use `__fisher_complete` to create completions from wtc usage output.

```
wtc --help | __fisher_complete wtc
```

### Docs

Create a man/man1 directory and add a man(1) page for wtc.

There are utilities that can help you generate man pages from various text formats. For example, pandoc(1) and ronn(1).

To create a man page manually.

```fish
mkdir -p man/man1
cat > man/man1/wtc.1

 .TH man 1 "Today" "1.0" "wtc man page"
 .SH NAME
 wtc \- Generate a random commit message
 .SH SYNOPSIS
 wtc [--help]
 .SH OPTIONS
 -h, --help: Display help information.
 .SH SEE ALSO
 https://github.com/ngerakines/commitment
^C
```

### Dependencies

A plugin can list dependencies to other plugins using a *fishfile*.

Create a new file in the root of your project and add the name or URL of your desired dependencies.

```fish
cat > fishfile
my_plugin
https://github.com/owner/another_plugin
^D
```

### Prompts

Prompts, also known as themes, are plugins that modify the appearance of the shell prompt and modify fish syntax colors.

Create a `fish_prompt` function.

```fish
function fish_prompt
    printf "%s (%s) >> " (prompt_pwd) Fisherman
end
~ (Fisherman) >> type here
```

To add a right prompt, create a `fish_right_prompt` function.

```fish
function fish_right_prompt
    printf "%s" (date +%H:%M:%S)
end
```

Save the functions to a directory and install the prompt as a plugin.

```fish
mkdir my_prompt
cd my_prompt
functions fish_prompt > fish_prompt.fish
functions fish_right_prompt > fish_right_prompt.fish
fisher install .
```

Customize the colors fish uses for syntax highlighting.

```fish
function set_color_custom
    set -U fish_color_normal    normal
    set -U fish_color_command   yellow
    set -U fish_color_param     white
end
functions set_color_custom > set_color_custom.fish
fisher update .
```

### Commands

Commands are plugins that extend the Fisherman CLI adding new `fisher <commands>`.

Create a function `fisher_<command>`

```fish
function fisher_time -d "Say hello"
    printf "It's %s\n" (date +%H:%M)
end
```

Test it works

```fish
fisher time
It's 6:30
```

Make it a plugin


```fish
fisher install fisher_time
```

This creates a new directory fisher_time in the current working directory and installs the plugin.

The following example implements a command to format plugin information into columns.

```fish
function fisher_info -d "Display information about plugins"
    switch "$argv"
        case -h --help
            printf "Usage: fisher info <name or URL> [...]\n\n"
            printf "    -h --help  Show usage help\n"
            return
    end

    for item in $argv
        fisher search $item --name --info
    end | sed -E 's/;/: /' | column
end

fisher install fisher_info
```

### Snippets

Snippets are plugins that run code at the start of the shell. Snippets must be placed inside a sub directory named conf.d.

The following example implements the fish_postexec hook to display the runtime of the last command in milliseconds.

```fish
mkdir -p runtime/conf.d
cd runtime
cat > conf.d/fish_postexec.fish
function fish_postexec --on-event fish_postexec
    printf "%sms\n" $CMD_DURATION > /dev/stderr
end
^D
fisher install ./postexec
```

[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square

[version-badge]: https://img.shields.io/badge/latest-v1.3.0-00B9FF.svg?style=flat-square
[version-link]: https://github.com/fisherman/fisherman/releases

[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square

[play]: https://cloud.githubusercontent.com/assets/8317250/13458315/dfcac4b4-e0af-11e5-8ee5-df31d1cdf409.png
[play-link]: http://fisherman.sh/#demo

[Get Started]: https://github.com/fisherman/fisherman/wiki
[Plugins]: http://fisherman.sh/#search
[fish]: https://github.com/fish-shell/fish-shell

[other]: https://github.com/fisherman/fisherman/wiki/Installing-Fisherman#notes
[Fisherman]: http://fisherman.sh
