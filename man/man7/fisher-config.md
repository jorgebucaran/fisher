fisher-config(7) -- Fisherman Configuration
===========================================

## SYNOPSIS

This document describes how to use Fisherman configuration variables.

## DESCRIPTION

Your fish user configuration, usually located in `$XDG_CONFIG_HOME/fish/config.fish` is updated after installing Fisherman to add the global variables `$fisher_home` and `$fisher_config`.

`$fisher_home` is the directory where Fisherman is downloaded to a

`$fisher_config` is the user configuration directory and the

Using the following variables, you can customize the locations of the cache, index URL, fishfile, create command aliases, etc.

## VARIABLES

* `$fisher_home`:
    The home directory. If you installed Fisherman using the recommended method `curl -sL install.fisherman.sh | fish`, the location will be `$XDG_DATA_HOME/fisherman`. If you clone Fisherman and run `make` yourself, `$fisher_home` will the current working directory.

* `$fisher_config`:
    The user configuration directory. This is default location of your user *fishfile*, Fisherman *key_bindings.fish* file and the *cache*, *functions*, *completions*, *conf.d* and *scripts* directories. `$XDG_CONFIG_HOME/fisherman` by default.

* `$fisher_file`:
    This file keeps a list of what plugins you have installed and are currently enabled. `$fisher_cofig/fishfile` by default. See `fisher help fishfile` for details.

* `$fisher_cache`:
    The cache directory. Plugins are downloaded first here and installed to `$fisher_config/functions` afterwards. The cache is `$fisher_config/cache` by default.

* `$fisher_index`:
    The URL to the index database. To use a different index set this to a file or URL. Redirect URLs are currently not supported due to security and performance concerns. The underlying request and fetch mechanism is based in `curl(1)`.

* `$fisher_alias command=alias[,...] [command2=alias[,...]]`:
    Use this variable to define custom aliases for fisher commands. See `Examples` below.

## EXAMPLES

* Create aliases for fisher `install` to *i*, *in* and *inst*; and for fisher `update` to *up*.

```
set fisher_alias install=i,in,inst update=up
```

## SEE ALSO

fisher help tour
