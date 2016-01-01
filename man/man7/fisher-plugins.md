fisher-plugins(7) -- Creating Fisherman Plugins
===============================================

## DESCRIPTION

This document describes how to create Fisherman plugins. This includes stand-alone utilities, prompts, extension commands and configuration plugins.

There is no technical distinction between any of the terms aforementioned, but there is a *conceptual* difference.

## DEFINITIONS

* `Standalone Utilities`: Plugins that define one or more functions, meant to be used at the command line.

* `Prompts / Themes`: Plugins that modify the appearance of the fish prompt by defining a `fish_prompt` and / or `fish_right_prompt` functions.

* `Extension Commands`: Plugins that extend Fisherman default commands. An extension plugin must define one or more functions like `fisher_<my_command>`. For specific information about commands, see `fisher help commands` and then return to this guide.

* `Configuration Plugins`: Plugins that include one or more `my_plugin`.config.fish files. Files that follow this convention are evaluated at the start of the session.

The following tree is that of a plugin that displays the characteristics of all the plugins described above.

```
my_plugin
|-- fisher_my_plugin.fish
|-- my_plugin.fish
|-- fish_prompt.fish
|-- fish_right_prompt.fish
|-- my_plugin.config.fish
|-- functions/
|   |-- my_plugin_helper.fish
|-- completions/
|   |-- my_plugin.fish
|-- man/
    |-- man1/
        |-- my_plugin.1
```

Plugins may list any number of dependencies to other plugins using a *fishfile*, see `fisher help fishfile`.

Plugins may also define completions using `complete`(1) and provide documentation in the form of `man`(1) pages.

## EXAMPLE

This section walks you through creating *wtc*, a stand-alone plugin based in *github.com/ngerakines/commitment* random commit message generator.


* Navigate to your preferred workspace and create the plugin's directory and Git repository:

    `mkdir` -p my/workspace/wtc; and `cd` my/workspace/wtc<br>
    `git` init<br>
    `git` remote add origin https://github.com/*owner*/wtc<br>


* Add the implementation.

    `cat` > wtc.fish

```
function wtc -d "Generate a random commit message"
    switch "$argv"
        case -h --help
            printf "usage: wtc [--help]\n\n"
            printf "  -h --help  Show usage help\n"
            return
    end
    curl -s whatthecommit.com/index.txt
end
^C
```

* Add completions. *wtc* is simple enough that you could get away without `__fish_parse_usage`, but more complex utilities, or utilities whose CLI evolves over time, can benefit using automatic completion generation. Note that in order to use `__fish_parse_usage`, your command must provide a `--help` option that prints usage information to standard output.

    `mkdir` completions<br>
    `cat` > completions/wtc.fish

```
set -l IFS ";"
wtc --help | __fish_parse_usage | while read -l info long short
    complete -c wtc -s "$short" -l "$long" -d "$info"
end
^C
```

* Add basic documentation. Fisherman uses standard manual pages for displaying help information. There are utilities that can help you generate man pages from other text formats, such as Markdown. One example is `ronn`(1). For this example, type will do:


    `mkdir` -p man/man1<br>
    `cat` > man/man1/wtc.1

    ```
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

* Commit changes and push to remote repository.

    `git` add --all<br>
    `git` commit -m "What the commit? 1.0"<br>
    `git` push origin master<br>


* Install with Fisherman. If you would like to submit your package for registration install the `submit` plugin or send a pull request to the main index repository in *https://github.com/fisherman/index*. See  `fisher`(7)#{`Index`} for details.


    fisher install github/*owner*/wtc<br>
    wtc<br>
    (\ /)<br>
    (O.o)<br>
    (> <) Bunny approves these changes.<br>


## SEE ALSO

`man`(1)<br>
`complete`(1)<br>
`fisher help commands`<br>
`fisher help fishfile`<br>
`fisher`(7)#{`Index`}<br>
