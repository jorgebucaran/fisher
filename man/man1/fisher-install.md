fisher-install(1) -- Install plugins
====================================

## SYNOPSIS

fisher install [*plugins* ...] [--force] [--quiet] [--help]

## USAGE

fisher install *url*<br>
fisher install *name*<br>
fisher install *path* <br>
fisher install *owner/repo*<br>
fisher install *function*<br>

## DESCRIPTION

Install one or more plugins, by name, URL, path or function name. If no arguments are given, read the standard input.

In addition, all of the following owner/repo variations are accepted:

* owner/repo *https://github.com/owner/repo*
* github/owner/repo *https://github.com/owner/repo*
* gh/owner/repo *https://github.com/owner/repo*

Shortcuts to other common Git repository hosting services are also available:

* bb/owner/repo *https://bitbucket.org/owner/repo*
* gl/owner/repo *https://gitlab.com/owner/repo*
* omf/owner/repo *https://github.com/oh-my-fish/repo*

If a URL is given, the repository is cloned to $fisher_cache the first time and any relevant plugin files are copied to $fisher_config functions, completions, conf.d and man directories.

If the plugin already exists in $fisher_cache, the files are only copied to $fisher_config. To update a plugin use fisher update.

If the plugin declares dependencies, these will be installed too. If any of the dependencies are already enabled or downloaded to the cache, they will not be updated to prevent version issues.

If a plugin includes either a fish_prompt.fish or fish_right_prompt.fish, both files are first removed from $fisher_config/functions and then the new ones are copied.

## OPTIONS

* -f, --force:
    Reinstall given plugin/s.

* -q, --quiet:
    Enable quiet mode.

* -h, --help:
    Show usage help.

## DIRECTORY TREE

The directory tree in *my_plugin*

```
my_plugin
|-- README.md
|-- my_plugin.fish
|-- functions
|   `-- my_plugin_helper.fish
|-- completions
|   `-- my_plugin.fish
|-- test
|   `-- my_plugin.fish
`-- man
    `-- man1
        `-- my_plugin.1
```

The directory tree in $fisher_config after running fisher install my_plugin:

```
$fisher_config
|-- functions
|   |-- my_plugin.fish
|   `-- my_plugin_helper.fish
|-- completions
|   `-- my_plugin.fish
|-- man
|   `-- man1
|       `-- my_plugin.1
`-- cache
    |-- my_other_plugin
    `-- my_plugin/...
```

## SNIPPETS

Snippets are plugins that run code at the start of the shell. Snippets must be placed inside a sub directory named conf.d.

## EXAMPLES

* Install plugins from multiple sources.

```fish
fisher install fishtape simnalamburt/shellder ~/plugins/my_plugin
```

## SEE ALSO

fisher help uninstall<br>
