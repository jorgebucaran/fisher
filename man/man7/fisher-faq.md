fisher-faq(7) -- Frequently Asked Questions
===========================================

## SYNOPSIS

This document attempts to answer some of Fisherman most frequently asked questions. Feel free to create a new issue in the Fisherman issue tracker if your question is not answered here.

### What is Fisherman?

Fisherman is a fish plugin manager that lets you share and reuse code, prompts and configurations easily.

### What do I need to know to use Fisherman?

Nothing, continue to use fish as usual. Ready to learn more? Type `fisher help` or `fisher help tour`.

### How do I access the documentation?

Fisherman documentation is based in UNIX `man`(1) pages. For basic usage and command enter `fisher help`. For help about a specific *command*, enter `fisher help <command>`. The following guides are also available:

fisher help `faq`: Fisherman FAQ<br>
fisher help `tour`: Fisherman Tour<br>
fisher help `config`: Fisherman Configuration<br>
fisher help `plugins`: Creating Fisherman Plugins<br>
fisher help `commands`: Creating Fisherman Commands<br>
fisher help `fishfile`: Fishfile Format<br>

### What are Fisherman plugins?

Plugins are written in fish and extend the shell core functionality, run initialization code, add completions or documentations to other commands, etc. See `fisher help plugins`.

Plugins may list any number of dependencies to other plugins using a *fishfile*.

### What is a Fishfile?

A plain text file consists of a lists of installed plugins or dependencies to other plugins.

Fishfiles let you share plugin configurations across multiple installations, allow plugins to declare dependencies, and prevent information loss in case of system failure. See also `fisher help fishfile`.

### What kind of Fisherman plugins are there?

There is no technical distinction between plugins, themes, commands, etc., but there is a *conceptual* difference.

* `Standalone Utilities`: Plugins that define one or more functions, meant to be used at the command line.

* `Prompts / Themes`: Plugins that modify the appearance of the fish prompt by defining a `fish_prompt` and / or `fish_right_prompt` functions.

* `Extension Commands`: Plugins that extend Fisherman default commands. An extension plugin must define one or more functions like `fisher_<my_command>`. For specific information about commands, see `fisher help commands` and then return to this guide.

* `Configuration Plugins`: Plugins that include one or more `my_plugin.config.fish` files. Files that follow this convention are evaluated at the start of the session.

See `fisher help plugins` and `fisher help commands`.

### Does Fisherman support Oh My Fish plugins and themes?

Yes. To install either a plugin or theme use their URL:

```
fisher install omf/plugin-{rbenv,tab} omf/theme-scorphish
```

You can use the same mechanism to install any valid plugin from any given URL. See also `Compatibility` in `fisher help tour`.

### What does Fisherman do exactly every time I create a new shell session?

Essentially, add Fisherman functions and completions to the `$fish_{function,complete}_path` and evaluate files that follow the convention `*.config.fish`.

```fish
set fish_function_path {$fisher_config,$fisher_home}/functions $fish_function_path
set fish_complete_path {$fisher_config,$fisher_home}/completions $fish_complete_path

for file in $fisher_config/conf.d/*.config.fish
    source $file
end
```

See `$fisher_home/config.fish` for the full code.

### How is Fisherman faster than Oh My Fish and other systems?

Fisherman ameliorates the slow shell start problem using a flat dependency tree instead of loading a directory hierarchy per plugin. This also means that Fisherman performance does not decline depending on the number of plugins installed. See also `Flat Tree` in `fisher help tour`.

### How can I upgrade from an existing Oh My Fish! installation?

Remove the `$OMF_PATH` and `$OMF_CONFIG` variables from your `config.fish`.

Backup dotfiles and other sensitive data.

```fish
rm -rf {$OMF_PATH,$OMF_CONFIG}
```

Install Fisherman.

```
curl -sL install.fisherman.sh | fish
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
