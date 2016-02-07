fisher-commands(7) -- Creating Fisherman Commands
=================================================

## SYNOPSIS

This document describes how to add new commands to Fisherman. A Fisherman command is a function that you can invoke using the `fisher` CLI, for example:

```fish
fisher my_command [*options*]
```

## DESCRIPTION

To add a command, create a function `fisher_<my_command>`:

```fish
function fisher_hello -d "Hello, how are you?"
    echo hello
end
```

Test it works: `fisher hello`.

To make this function available to future fish sessions, add it to `$XDG_CONFIG_HOME/fish/functions`:

```fish
funcsave fisher_hello
```

You can also create a local plugin and install it with Fisherman:

```fish
mkdir fisher_hello
cd fisher_hello
functions fisher_hello > fisher_hello.fish
fisher install .
```

The method described above will create a symbolic link to the `fisher_hello` directory and `fisher_hello.fish` inside `$fisher_config/functions`.

## EXAMPLES

The following example implements a command to retrieve plugin information and format the output into columns.

```fish
function fisher_info -d "Display information about plugins"
    switch "$argv"
        case -h --help
            printf "usage: fisher info name | URL [...]\n\n"
            printf "    -h --help  Show usage help\n"
            return
    end

    for item in $argv
        fisher search $item --name --info
    end | sed -E 's/;/: /' | column
end
```

## SEE ALSO

fisher(1)<br>
fisher help tour<br>
funcsave(1)<br>
fisher help plugins<br>
