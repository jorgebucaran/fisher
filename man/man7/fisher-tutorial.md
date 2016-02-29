fisher-tutorial(7) -- A tutorial introduction to Fisherman
==========================================================

## DESCRIPTION

This document tells you how to start using Fisherman key features.

## INSTALLING PLUGINS

Install a plugin.

```
fisher install <plugin>
```

*plugin* can be name registered in the Fisherman index, a URL to a Git repository or a path in the local system. Plugins are collected in a special location inside the Fisherman's configuration directory known as the cache.

## UPDATE AND UNINSTALL

Update a plugin.

```
fisher update <plugin>
```

Uninstall a plugin.

```
fisher uninstall <plugin>
```

## LIST AND SEARCH

The list command displays all the plugins you have installed. The search command queries the index to show what's available to install.

List installed plugins.

```
fisher list
  debug
* fishtape
> shellder
* spin
@ wipe
```

The legend consists of:

`*` Indicate the plugin is currently installed<br>
`>` Indicate the plugin is a prompt<br>
`@` Indicate the plugin is a symbolic link<br>

Search the index.

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

Get detailed information about a plugin.

```
fisher search shellder
> shellder by simnalamburt
Powerline prompt optimized for speed
github.com/simnalamburt/shellder
```

Search plugins using tags.

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

## PLUMBING

Fisherman commands are pipe aware. Plumb one with another to create complex functionality.

Update all the plugins in the cache.

```fish
fisher list | fisher update -
```

Install all the plugins that are currently disabled.

```fish
fisher list --disabled | fisher install
```

## DOTFILES

When you install a plugin, Fisherman updates a file known as *fishfile* to track what plugins are currently enabled.

To customize its location:

```fish
set -g fisher_file ~/.dotfiles/fishfile
```

## PLUGINS

Plugins can be utilities, prompts, commands or snippets.

### UTILITIES

Utilities are plugins that define one or more functions which are mean to be used in the CLI directly by the user.

This example walks you through creating *wtc*, a plugin based in *github/ngerakines/commitment* random commit message generator.

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

#### SUBMIT

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

#### COMPLETIONS

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

#### MAN

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

#### DEPENDENCIES

A plugin can list dependencies to other plugins using a *fishfile*.

Create a new file in the root of your project and add the name or URL of your desired dependencies.

```fish
cat > fishfile
my_plugin
https://github.com/owner/another_plugin
^D
```

### PROMPTS

Prompts, also known as themes, are plugins that modify the appearance of the shell prompt.

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

### COMMANDS

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

### SNIPPETS

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

## SEE ALSO

fisher(1)
