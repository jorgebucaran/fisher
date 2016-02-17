fisher-install(1) -- Install Plugins
====================================

## SYNOPSIS

fisher `install` [*plugins* ...] [`--force`] [`--quiet`] [`--help`]

## USAGE

fisher `install` *url* ...<br>
fisher `install` *name* ...<br>
fisher `install` *path*  ...<br>
fisher `install` *owner/repo* ...<br>

## DESCRIPTION

Install one or more plugins, by name, URL or a local path. If no arguments are given, read the standard input.

In addition, all of the following `owner/repo` variations are accepted:

* owner/repo `>` https://github.com/owner/repo<br>
* *github*/owner/repo `>` https://github.com/owner/repo<br>
* *gh*/owner/repo `>` https://github.com/owner/repo<br>

Shortcuts to other common Git repository hosting services are also available:

* *bb*/owner/repo `>` https://bitbucket.org/owner/repo<br>
* *gl*/owner/repo `>` https://gitlab.com/owner/repo<br>
* *omf*/owner/repo `>` https://github.com/oh-my-fish/repo<br>

If a URL is given, the repository is cloned to `$fisher_cache` the first time and any relevant plugin files are copied to `$fisher_config` functions, completions, conf.d and man directories.

If the plugin already exists in `$fisher_cache`, the files are only copied to `$fisher_config`. To update a plugin use `fisher update`.

If the plugin declares dependencies, these will be installed too. If any of the dependencies are already enabled or downloaded to the cache, they will not be updated to prevent version issues. See *Plugins* in `fisher help fishfile`.

If a plugin includes either a `fish_prompt.fish` or `fish_right_prompt.fish`, both files are first removed from `$fisher_config/functions` and then the new ones are copied.

## OPTIONS

* `-f` `--force`:
    Reinstall given plugin/s. If the plugin is already in the cache, it will be installed from the cache.

* `-q` `--quiet`:
    Enable quiet mode.

* `-h` `--help`:
    Show usage help.

## EXAMPLES

Here is the directory tree of *my_plugin*:

```
my_plugin
|-- README.md
|-- my_plugin.fish
|-- functions
|   |-- my_plugin_helper.fish
|-- completions
|   |-- my_plugin.fish
|-- test
|   |-- my_plugin.fish
|-- man
    |-- man1
        |-- my_plugin.1
```

And here is the directory tree of `$fisher_config/` after running `fisher install my_plugin`:

```
$fisher_config
|-- functions
    |-- my_plugin.fish
    |-- my_plugin_helper.fish
|-- completions
    |-- my_plugin.fish
|-- man
    |-- man1
        |-- my_plugin.1
|-- cache
    |-- my_other_plugin
    |-- my_plugin/...
```

In addition, any `init.fish` and `*.config.fish` files, are copied to `$fisher_config/conf.d` and evaluated during the start of the shell.

To prevent name collisions, `init.fish` files are renamed to `my_plugin.init.fish`.

## EXAMPLES

* Install plugins from multiple sources.

```fisher
fisher install fishtape simnalamburt/shellder ~/plugins/my_plugin
```

## SEE ALSO

fisher(1)<br>
fisher help config<br>
fisher help update<br>
fisher help uninstall<br>
