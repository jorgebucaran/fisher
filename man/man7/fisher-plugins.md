fisher-plugins(7) -- Creating Fisherman Plugins
===============================================

## DESCRIPTION

This document describes how to create Fisherman plugins. This includes stand-alone utilities, prompts, extension commands and configuration plugins.

There is no technical distinction between any of the terms aforementioned, but there is a *conceptual* difference.

## DEFINITIONS

* `Standalone Utilities`: Plugins that define one or more functions.

* `Prompts / Themes`: Plugins that modify the appearance of the fish prompt by defining a `fish_prompt` / `fish_right_prompt` function/s.

* `Extension Commands`: Plugins that extend Fisherman default commands. An extension plugin must define one or more functions like `fisher_<my_command>`. For specific information about commands, see `fisher help commands`.

* `Configuration Plugins`: Plugins that include one or more `my_plugin.config.fish` files. Files that follow this convention are evaluated at the start of the session. If a file does not follow the `<my_plugin>.config.fish` convention, it must be added to `conf.d/*.fish` and the `<my_plugin>` name will be prepended to the file during the installation process.

An example plugin that follows several of the conventions proposed above.

```
my_plugin
|-- fisher_my_plugin.fish
|-- my_plugin.fish
|-- fish_prompt.fish
|-- fish_right_prompt.fish
|-- my_plugin.config.fish
|-- functions
|   |-- my_plugin_helper.fish
|-- conf.d
|   |-- *.fish
|-- completions
|   |-- my_plugin.fish
|-- man
    |-- man1
        |-- my_plugin.1
```

## DEPENDENCIES

A plugin may list any number of dependencies to other plugins using a *fishfile*, see `fisher help fishfile`.

For example, if `<my_plugin>` depends on `<your_plugin>`, add this dependency into a fishfile at the root of the project:

```
cat > my_plugin/fishfile
your_plugin
CTRL^D
```

Plugins may also define completions using `complete(1)` and provide documentation in the form of `man(1)` pages.

## EXAMPLE

This section walks you through creating *wtc*, a stand-alone plugin based in *github.com/ngerakines/commitment* random commit message generator.

* Navigate to your preferred workspace and create the plugin's directory and Git repository:

```fish
mkdir -p my/workspace/wtc; and cd my/workspace/wtc
git init
git remote add origin https://github.com/<owner>/wtc
```

* Add the implementation.

```fish
cat > wtc.fish

function wtc -d "Generate a random commit message"
    switch "$argv"
        case -h --help
            printf "Usage: wtc [--help]\n\n"
            printf "  -h --help  Show usage help\n"
            return
    end
    curl -s whatthecommit.com/index.txt
end
^C
```

* Add completions. *wtc* is simple enough that you could get away without `__fisher_parse_help`, but more complex utilities, or utilities whose CLI evolves over time, can benefit using automatic completion generation. Note that in order to use `__fisher_parse_help`, your command must provide a `--help` option that prints usage information to standard output.

```fish
mkdir completions
cat > completions/wtc.fish

set -l IFS ";"
wtc --help | __fisher_parse_help | while read -l info long short
    complete -c wtc -s "$short" -l "$long" -d "$info"
end
^C
```

* Add basic documentation. Fisherman uses standard manual pages for displaying help information. There are utilities that can help you generate man pages from other text formats, such as Markdown. One example is `ronn(1)`. For this example, type will do:

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

* Commit changes and push to the remote repository.

```fish
git add --all
git commit -m "What the commit? 1.0"
git push origin master
```

* Install with Fisherman. If you would like to submit your package for registration install the `submit` plugin or send a pull request to the main index repository in *https://github.com/fisherman/index*. See `Index` in `fisher help tour`.

```fish
fisher install github/*owner*/wtc
wtc
(\ /)
(O.o)
(> <) Bunny approves these changes.
```

## SEE ALSO

man(1)<br>
complete(1)<br>
fisher help commands<br>
fisher help fishfile<br>
