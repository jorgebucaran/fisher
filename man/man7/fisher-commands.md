fisher-commands(7) -- Creating Fisherman Commands
=================================================

## SYNOPSIS

This document describes how to add new commands to Fisherman. A Fisherman command is a function that you can invoke like `fisher command` [*options*].


## DESCRIPTION

To add a command, create a function `fisher_<my_command>`:

```
function fisher_hello -d "Friendly command"
    echo hello
end
```

Make sure it works: `fisher hello`.

To make this function available to the current and future fish sessions, add it to `$XDG_CONFIG_HOME`/fish/functions:

```
funcsave fisher_hello
```

You may also choose to save this function to `$fisher_config`/functions.

## EXAMPLES

The following example implements a command to retrieve plugin information and format the output into columns.

```
function fisher_info -d "Display information about plugins"
    switch "$argv"
        case -h --help
            printf "usage: fisher info name | url [...]\n\n"
            printf "  -h --help  Show usage help\n"
            return
    end
    for item in $argv
        fisher search $item --name --info
    end | sed -E 's/;/: /' | column
end
```

## SEE ALSO

`fisher`(1)<br>
`fisher`(7)<br>
`funcsave`(1)<br>
`fisher help plugins`<br>
