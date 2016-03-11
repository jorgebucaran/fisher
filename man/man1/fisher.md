fisher(1) -- Fish plugin manager
================================

## SYNOPSIS

fisher *command* [*options*] [--version] [--help]<br>

## DESCRIPTION

Fisherman is a plugin manager for fish.

The Fisherman CLI consists of: *install*, *update*, *uninstall*, *list*, *search* and *help* and the following aliases: *i* for install, *u* for update, *l* for list, *s* for search and *h* for help.

## USAGE

Run a command.

```
fisher <command> [<options>]
```

Get help about a command.

```
fisher help <command>
```

## OPTIONS

* -v, --version:
    Show version information. Fisherman follows Semantic Versioning and uses Git annotated tags to track releases.

* -h, --help:
    Show usage help.

## EXAMPLES

Install plugins.

```fish
fisher install fishtape shark get
```

Install a plugin from a local directory.

```fish
fisher install ./path/to/plugin
```

Install a plugin from a URL.

```fish
fisher install owner/repo
```

Install a plugin from a Gist URL.

```fish
fisher install gist.github.com/owner/1f40e1c6e0551b2666b2
```

Update Fisherman.

```fish
fisher update
```

Update plugins.

```
fisher update shark get
```

Uninstall plugins.

```
fisher uninstall fishtape debug
```

Uninstall plugins and remove them from the cache.

```
fisher uninstall fishtape debug -f
```

Show all the documentation.

```fish
fisher help --all
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

The legend consists of:

`*` The plugin is currently enabled<br>
`>` The plugin is a prompt<br>
`@` The plugin is a symbolic link<br>

## PLUMBING

Fisherman commands are pipe aware. Plumb one with another to create complex functionality.

Update all the plugins in the cache.

```fish
fisher list | fisher update -
```

Enable all the plugins that are currently disabled.

```fish
fisher list --disabled | fisher install
```

Uninstall all the plugins and remove them from the cache.

```fish
fisher list | fisher uninstall --force
```

## DOTFILES

When you install a plugin, Fisherman updates a file known as *fishfile* to track what plugins are currently enabled.

To customize its location:

```fish
set -g fisher_file ~/.dotfiles/fishfile
```

## FLAT TREE

Fisherman merges the directory trees of all the plugins it installs into a single flat tree. Since the flat tree is loaded only once at the start of the shell, Fisherman performs equally well, regardless of the number of plugins installed.

The following illustrates an example Fisherman configuration path with a single plugin and prompt.

```
$fisher_config
|-- cache/
|-- conf.d/
|   `-- my_plugin.fish
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

## INDEX

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

If you have a plugin to submit to the index, use the *submit* plugin.

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

## FISHFILE

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

## VARIABLES

* $fisher_home:
    The home directory. If you installed Fisherman using the recommended method `curl -sL install.fisherman.sh | fish`, the location ought to be *XDG_DATA_HOME/fisherman*. If you clone Fisherman and run make yourself, the current working directory is used by default.

* $fisher_config:
    The configuration directory. This is default location of the *fishfile*, *key_bindings.fish*, *cache*, *functions*, *completions* and *conf.d* directories. The default location is *XDG_CONFIG_HOME/fisherman*.

* $fisher_file:
    See FISHFILE above.

* $fisher_cache:
    The cache directory. Plugins are downloaded to this location.

* $fisher_alias *command*=*alias* ...:
    Use this variable to create aliases of Fisherman commands.


## PLUGINS

Plugins can be utilities, prompts, commands or snippets. To create a plugin from a template, install the new command.

```
fisher install new
fisher new plugin < meta.yml
```

See the documentation of new for details.

### UTILITIES

Utilities are plugins that define one or more functions.

This example walks you through creating *wtc*, a plugin based in *github/ngerakines/commitment* random commit message generator.

Create a directory and initialize a Git repository.

```fish
mkdir wtc
cd wtc
git init
git remote add origin https://github.com/<you>/wtc
```

Add the wtc function.

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
functions wtc > wtc.fish
```

Install the plugin.

```fish
fisher install .
wtc
(\ /)
(O.o)
(> <) Bunny approves these changes.
```

Commit changes and push to your remote origin when you are done.

```fish
git add --all
git commit -m "What the commit?"
git push origin master
```

#### SUBMIT

To submit wtc to the official index.

```fish
fisher submit wtc "Random commit message generator" "commit random fun" https://github.com/owner/wtc
```

This will create a PR in the Fisherman index repository. Once the PR is approved, Fisherman users will be able to install wtc if they have the latest index.

```fish
fisher install wtc
```

#### COMPLETIONS

Create a completions directory and add a completions file.

```fish
mkdir completions
$EDITOR completions/wtc.fish
```

```fish
complete --command wtc --short h --long help --description "Show usage help"
```

Or use `__fisher_complete` to create completions from wtc usage output.

```
wtc --help | __fisher_complete wtc
```

#### DOCS

Create a man/man1 directory and add a man(1) page for wtc.

There are utilities that can help you generate man pages from various text formats. For example, pandoc(1) and ronn(1).

To create a man page manually.

```
mkdir -p man/man1
$EDITOR man/man1/wtc.1
```

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
```

#### DEPENDENCIES

A plugin can list dependencies to other plugins using a *fishfile*.

Create a new file in the root of your project and add the name or URL of your dependencies.

```fish
cat > fishfile
my_plugin
https://github.com/owner/another_plugin
^D
```

### PROMPTS

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
    set -U fish_color_normal                #...
    set -U fish_color_command               #...
    set -U fish_color_param                 #...
    set -U fish_color_redirection           #...
    set -U fish_color_comment               #...
    set -U fish_color_error                 #...
    set -U fish_color_escape                #...
    set -U fish_color_operator              #...
    set -U fish_color_end                   #...
    set -U fish_color_quote                 #...
    set -U fish_color_autosuggestion        #...
    set -U fish_color_valid_path            #...
    set -U fish_color_cwd                   #...
    set -U fish_color_cwd_root              #...
    set -U fish_color_match                 #...
    set -U fish_color_search_match          #...
    set -U fish_color_selection             #...
    set -U fish_pager_color_prefix          #...
    set -U fish_pager_color_completion      #...
    set -U fish_pager_color_description     #...
    set -U fish_pager_color_progress        #...
    set -U fish_color_history_current       #...
end
functions set_color_custom > set_color_custom.fish
fisher update .
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

## AUTHORS

Fisherman was created by Jorge Bucaran :: @bucaran :: *j@bucaran.me*.

See THANKS.md file for a complete list of contributors.

## SEE ALSO

fisher help tutorial<br>
