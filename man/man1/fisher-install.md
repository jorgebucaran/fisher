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

Install one or more plugins, by name, URL or local path. If no arguments are given, read the standard input.

If the Git host is not provided, Fisherman will use https://github.com by default.

In addition, all of the following `owner/repo` variations are accepted:

* owner/repo `>` https://github.com/owner/repo<br>
* *github*/owner/repo `>` https://github.com/owner/repo<br>
* *gh*/owner/repo `>` https://github.com/owner/repo<br>

Shortcuts to other common Git repository hosting services are also available:

* *bb*/owner/repo `>` https://bitbucket.org/owner/repo<br>
* *gl*/owner/repo `>` https://gitlab.com/owner/repo<br>
* *omf*/owner/repo `>` https://github.com/oh-my-fish/repo<br>

If a URL is given, the repository is cloned to `$fisher_cache` the first time and any relevant plugin files are copied to `$fisher_config` functions, completions, conf.d and man directories.

If the plugin already exists in `$fisher_cache`, the files are copied to `$fisher_config`. To update a plugin use `fisher update`.

If the plugin declares dependencies, these will be installed too. If any of the dependencies are already enabled or downloaded to the cache, they will not be updated to prevent version issues. See *Plugins* in `fisher help fishfile`.

If a plugin includes either a fish_prompt.fish or fish_right_prompt.fish, both files are first removed from `$fisher_config/functions` and then the new ones are copied.

## OPTIONS

* `-f` `--force`:
    Reinstall given plugin/s. If the plugin is already in the cache, it will be installed from the cache.

* `-q` `--quiet`:
    Enable quiet mode.

* `-h` `--help`:
    Show usage help.

## INSTALL PROCESS

Here is the typical install process breakdown for *plugin*:

1. Check if *plugin* exists in `$fisher_index`. Fail otherwise.
2. Download *plugin* to `$fisher_cache` if not there already.
3. Copy all `*.fish` and `functions/*.fish` files to `$fisher_config/functions`.
4. Copy all `completions/*.fish` to `$fisher_config/completions`.
5. Copy all `init.fish` and `*.config.fish` files to `$fisher_config/conf.d`.
5. Copy all man/man% to `$fisher_config/man/man%`.

## EXAMPLES

Here is the directory tree of *my_plugin* somewhere deep under the sea:

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

In addition, any `init.fish` or `*.config.fish` files, are copied to `$fisher_config/conf.d` and evaluated during the start of the shell.

Notes: `init.fish` files are renamed to `my_plugin.init.fish` to prevent name collisions.

## SEE ALSO

fisher(1)<br>
fisher help config<br>
fisher help update<br>
fisher help uninstall<br>
