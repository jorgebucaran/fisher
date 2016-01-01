fisher-faq(7) -- Fisherman Frequently Asked Questions
=====================================================

## SYNOPSIS

This document attempts to answer some of Fisherman most frequently asked questions. Feel free to create a new issue in the Fisherman issue tracker if your question is not answered here.


### What is Fisherman?

Fisherman is a shell manager for fish that lets you share and reuse code, prompts and configurations easily.


### What do I need to know to use Fisherman?

Nothing. You can continue using your shell as usual. When you are ready to learn more just type `man fisher` or `man 7 fisher`.


### How do I access other Fisherman documentation?

Fisherman documentation is based in UNIX `man`(1) pages. See `man fisher` and `man 7 fisher` to get started. You can also access any documentation using the `fisher help` command.


### What are Fisherman plugins?

Plugins are written in fish and extend the shell core functionality, run initialization code, add completions or documentations to other commands, etc. See `fisher help plugins`.

Plugins may list any number of dependencies to other plugins using a *fishfile*.


### What is a Fishfile?

A plain text file that lists what plugins you have installed or a plugin's dependencies to other plugins.

Fishfiles let you share plugin configurations across multiple installations, allow plugins to declare dependencies, and prevent information loss in case of system failure. See also `fisher help fishfile`.


### What kind of Fisherman plugins are there?

There is no technical distinction between plugins, themes, commands, etc., but there is a *conceptual* difference.

* `Standalone Utilities`: Plugins that define one or more functions, meant to be used at the command line.

* `Prompts / Themes`: Plugins that modify the appearance of the fish prompt by defining a `fish_prompt` and / or `fish_right_prompt` functions.

* `Extension Commands`: Plugins that extend Fisherman default commands. An extension plugin must define one or more functions like `fisher_<my_command>`. For specific information about commands, see `fisher help commands` and then return to this guide.

* `Configuration Plugins`: Plugins that include one or more `my_plugin`.config.fish files. Files that follow this convention are evaluated at the start of the session.

See `fisher help plugins` and `fisher help commands`.


### Does Fisherman support Oh My Fish plugins and themes?

Yes. To install either a plugin or theme use their URL:

```
fisher install oh-my-fish/{rbenv,hub,bobthefish}
```

You can use the same mechanism to install a Wahoo package or a plugin in a any given URL. See also `fisher`(7)#{`Compatibility`}.


### What does Fisherman do exactly every time I create a new shell session?

Essentially, add Fisherman functions and completions to the `$fish_{function,complete}_path` and evaluate files that follow the convention `*.config.fish`.

```fish
set fish_function_path {$fisher_config,$fisher_home}/functions $fish_function_path
set fish_complete_path {$fisher_config,$fisher_home}/completions $fish_complete_path

for file in $fisher_config/functions/*.config.fish
    source $file
end
```

See `$fisher_home/config.fish` for the full code.


### How is Fisherman faster than Oh My Fish!, Wahoo, etc?

Fisherman ameliorates the slow shell start problem using a flat dependency tree instead of loading a directory hierarchy per plugin. This also means that Fisherman performance does not decline depending on the number of plugins installed. See also `fisher`(7)#{`Flat Tree`}.

### Why don't you contribute your improvements back to Oh My Fish! instead of creating a new project?

Already done that. See Oh My Fish! history for August 27, 2015. The project was then called Wahoo and it was entirely merged with Oh My Fish!.

Fisherman was built from the ground up using a completely different design, implementation and set of principles.

Some features include: UNIX familiarity, minimalistic design, flat tree structure, unified plugin system, external self-managed database, cache mechanism, dependency manifest file and compatibility with Oh My Fish!, etc. See `fisher`(7).


### How can I upgrade from an existing Oh My Fish! or Wahoo installation?

Install Fisherman.

```
git clone https://github.com/fisherman/fisherman
cd fisherman
make
```

You can now safely remove Oh My Fish! `$OMF_PATH` and `$OMF_CONFIG`.

Backup dotfiles and other sensitive data first.

```fish
rm -rf {$OMF_PATH,$OMF_CONFIG}
```


### I changed my prompt with `fish_config` and now I can't use any Fisherman theme, what do I do?

`fish_config` persists the prompt to `XDG_CONFIG_HOME/fish/functions`/fish_prompt.fish. That file takes precedence over Fisherman prompts that install to `$fisher_config`/functions/. To use Fisherman prompts remove the `fish_promt.fish` inside `XDG_CONFIG_HOME/fish/functions/`.

Assuming `XDG_CONFIG_HOME` is `~/.config` in your system:

```
rm ~/.config/fish/functions/fish_prompt.fish
```


### How do I use fish as my default shell?

Add Fish to `/etc/shells`:

```sh
echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
```

Make Fish your default shell:

```sh
chsh -s /usr/local/bin/fish
```

To switch back to another shell.

```sh
chsh -s /bin/another/shell
```


### Why is this FAQ similar to the Oh My Fish! FAQ?

Because it was written by the same author of Fisherman and Wahoo and some of the questions and answers simply overlap.
