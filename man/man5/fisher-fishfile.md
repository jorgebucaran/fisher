fisher-fishfile(5) -- Fishfile Format
=====================================

## SYNOPSIS

Fishfiles let you share plugin configurations across multiple installations, let plugins declare dependencies and teach Fisherman what plugins are currently enabled / disabled when using `fisher --list`.

Your fishfile is stored in `$fisher_config/fishfile` by default, but you can customize this location overriding the `$fisher_file` variable in your fish configuration file.

## USAGE

Fishfiles list one or more plugins by their name, URL or path to a local project.

Here is an example:

```
# Ahoy!

gitio
fishtape
shark
get
some_user/her_plugin
```

A fishfile may contain any amount of whitespace and comments.

If you need to parse a fishfile to list its plugins, for example, to pipe the input into `fisher install` or `fisher update`, you can use `fisher --list=path/to/fishfile`. Notice that Oh My Fish! bundle file syntax is also supported.

## PLUGINS

Plugins may list any number of dependencies to other plugins in a fishfile at the root of the project.

When a plugin is installed, its dependencies are downloaded for the first time. If a dependency is already installed, it is not updated in order to prevent breaking other plugins using a different version. Currently, uninstalling a plugin does not remove any its dependencies either.

To understand this behavior, it helps to recall the shell's single scope for functions. The lack of private functions means that, it is *not* possible to single-lock a specific dependency version. See also `Flat Tree` in `fisher help tour`.

## SEE ALSO

`fisher`(1)<br>
`fisher help config`<br>
