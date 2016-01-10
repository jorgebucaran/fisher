fisher-config(7) -- Fisherman Configuration
===========================================

## SYNOPSIS

This document describes how to use the available configuration options to customize Fisherman.

## DESCRIPTION

Your fish user configuration, usually located in `$XDG_CONFIG_HOME/fish/config.fish` is updated after installing Fisherman to add the global variables `$fisher_home` and `$fisher_config`.

`$fisher_home` is the directory where you downloaded Fisherman. This location can be anywhere you like. If you changed this location after installing Fisherman, you need to update `$fisher_home` as well.

`$fisher_config` is the user configuration directory and the location of your user *fishfile*, *cache* directory and where plugins get installed to. This location must be different from `$fisher_home`. The default location is `$XDG_CONFIG_HOME/fisherman`.

You can also customize the debug log path, cache location, index source URL, command aliases, and other options via `$fisher_*` variables.

## VARIABLES

* `$fisher_home`:
    The home directory. This is the path where you downloaded Fisherman.

* `$fisher_config`:
    The user configuration directory. `$XDG_CONFIG_HOME/fisherman` by default. This directory is where the *cache*, *functions* and *completions* directories are located.

* `$fisher_cache`:
    The cache directory. Plugins are first downloaded here and installed to `$fisher_config/functions` afterwards. The cache is `$fisher_config/cache` by default.

* `$fisher_index`:
    Index source URL or file. To use a different index set this to a file or URL. Redirect urls are not supported due to security and performance concerns. The underlying request and fetch mechanism is based in `curl(1)`. See also `Index` in `fisher help tour`.

* `$fisher_error_log`:
    This file keeps a log of the most recent crash stack trace. `$fisher_cache/.debug_log` by default.

* `$fisher_alias command=alias[,...] [command2=alias[,...]]`:
    Use this variable to define custom aliases for fisher commands. See `Examples` below.

* `$fisher_default_host`:
    Use this variable to define your preferred git host. Fisherman uses this value to convert short urls like `owner/repo` to `https://host/owner/repo`. The default host is *github.com*.

* `$fisher_share`:
    Used to share scripts other than `.fish` files between plugins. Use `$fisher_share_extensions` to customize what extensions are used.

* `$fisher_share_extensions`:
    Customize what file extensions are copied to `$fisher_config` when sharing scripts. By default `py rb php pl awk sed` are used.


## EXAMPLES

* Create aliases for fisher `install` to *i*, *in* and *inst*; and for fisher `update` to *up*.

```
set fisher_alias install=i,in,inst update=up
```

* Set `$fisher_index` and `$fisher_default_host`.

```
set fisher_index https://raw.../owner/repo/master/index2.txt
set fisher_default_host bitbucket.org
```

## SEE ALSO

fisher help tour
