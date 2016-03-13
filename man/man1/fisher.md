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

* Install plugins.

```
fisher i fishtape shark get bobthefish
```

* Install Oh My Fish! plugins.

```fish
fisher i omf/plugin-{percol,jump,fasd}
```

* Install a plugin from a local directory.

```fish
fisher i ./path/to/plugin
```

* Install a plugin from various URLs.

```fish
fisher i https://github.com/some/plugin another/plugin bb:one/more
```

* Install a plugin from a Gist.

```fish
fisher i gist.github.com/owner/1f40e1c6e0551b2666b2
```

* Update everything.

```
fisher u
```

* Update plugins.

```
fisher u shark get
```

* Uninstall plugins.

```
fisher uninstall fishtape debug
```

* Get help.

```fish
fisher h
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

Query the index using regular expressions.

```
fisher search --name~/git-is/
git-is-dirty       Test if there are changes not staged for commit
git-is-empty       Test if a repository is empty
git-is-repo        Test if the current directory is a Git repo
git-is-staged      Test if there are changes staged for commit
git-is-stashed     Test if there are changes in the stash
git-is-touched     Test if there are changes in the working tree
```

Search using tags.

```
fisher search --tag={git,test}
  ...
  * fishtape         TAP producing test runner
  git-branch-name    Get the name of the current Git branch
  git-is-dirty       Test if there are changes not staged for commit
  git-is-empty       Test if a repository is empty
  git-is-repo        Test if the current directory is a Git repo
  git-is-staged      Test if there are changes staged for commit
  git-is-stashed     Test if there are changes in the stash
  git-is-touched     Test if there are changes in the working tree
  ...
```

The legend consists of:

* `*` The plugin is enabled
* `>` The plugin is a prompt
* `@` The plugin is a symbolic link

## PLUMBING

Fisherman commands are pipe aware. Plumb one with another to create complex functionality.

Update plugins installed as symbolic links.

```fish
fisher list --link | fisher update -
```

Enable all the plugins currently disabled.

```fish
fisher list --disabled | fisher install
```

Uninstall all the plugins and remove them from the cache.

```fish
fisher list | fisher uninstall --force
```

## DOTFILES

When you install a plugin, Fisherman updates the *fishfile* to track what plugins are currently enabled.

* Customize the location of the fishfile.

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

The index lists records, each consisting the fields: *name*, *url*, *info*, one or more *tags* and *author*.

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
fisher submit my_plugin description tags url
```

Or, submit the plugin manually by creating a pull request in the [index](https://github.com/fisherman/fisher-index) repository.

## VARIABLES

* $fisher_home:
    The home directory. If you installed Fisherman using the recommended method, the location ought to be *XDG_DATA_HOME/fisherman*.

* $fisher_config:
    The configuration directory. This is default location of your *fishfile*, *key_bindings.fish*, *cache*, *functions*, *completions* and *conf.d* directories. *XDG_CONFIG_HOME/fisherman* by default.

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

Below is a plugin based in [ngerakines/commitment](https://github/ngerakines/commitment) random commit message generator.

```fish
mkdir wtc
cd wtc

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

fisher install .
```
```
wtc
(\ /)
(O.o)
(> <) Bunny approves these changes.
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

#### DEPENDENCIES

A plugin can list dependencies to other plugins using a *fishfile*.

Create a *fishfile* in the root of your project and add the name or URL of your dependencies.

```
my_plugin
https://github.com/owner/another_plugin
```

### PROMPTS

Prompts, or themes, are plugins that modify the appearance of the shell prompt and colors.

Create a `fish_prompt` function.

```fish
function fish_prompt
    printf "%s (%s) >> " (prompt_pwd) Fisherman
end
```
```
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
    # set -U fish_color_normal                
    # set -U fish_color_command               
    # set -U fish_color_param                 
    # set -U fish_color_redirection           
    # set -U fish_color_comment               
    # set -U fish_color_error                 
    # set -U fish_color_escape                
    # set -U fish_color_operator              
    # set -U fish_color_end                   
    # set -U fish_color_quote                 
    # set -U fish_color_autosuggestion        
    # set -U fish_color_valid_path            
    # set -U fish_color_cwd                   
    # set -U fish_color_cwd_root              
    # set -U fish_color_match                 
    # set -U fish_color_search_match          
    # set -U fish_color_selection             
    # set -U fish_pager_color_prefix          
    # set -U fish_pager_color_completion      
    # set -U fish_pager_color_description     
    # set -U fish_pager_color_progress        
    # set -U fish_color_history_current       
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

### SNIPPETS

Snippets are plugins that run code at the start of the shell. Snippets must be placed inside a sub directory named conf.d.

The following example implements a fish_postexec hook to display the duration of the last command in milliseconds.

```fish
mkdir -p runtime/conf.d
cd runtime
$EDITOR conf.d/fish_postexec.fish
```

```fish
function fish_postexec --on-event fish_postexec
    printf "%sms\n" $CMD_DURATION > /dev/stderr
end

fisher install ./postexec
```

## AUTHORS

Fisherman was created by Jorge Bucaran :: @bucaran :: *j@bucaran.me*.

See THANKS.md file for a complete list of contributors.
