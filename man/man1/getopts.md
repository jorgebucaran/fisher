getopts(1) -- Parse CLI options
===============================

## SYNOPSIS

`getopts` [*options* ...]<br>
`getopts` [*options* ...] `|` `while` read -l key value; ...; `end`<br>

## DESCRIPTION

**Getopts** is a command line options parser for fish.

## USAGE

The best way to understand how getopts work is by studying a basic example.

```
getopts -ab1 --foo=bar baz
```

And its output.

```
a
b    1
foo  bar
_    baz
```

The items on the left represent the option flags or *keys* associated with the CLI. The items on the right are the option *values*. The underscore `_` character is the default *key* for arguments without a key.

Use `read`(1) to process the generated stream and `switch`(1) to match patterns:

```
getopts -ab1 --foo=bar baz | while read -l key option
    switch $key
        case _
        case a
        case b
        case foo
    end
end
```

## EXAMPLES

The following is a mock of `fish`(1) CLI.

```
function fish
    set -l mode
    set -l flags
    set -l commands
    set -l debug_level

    getopts $argv | while read -l key value
        switch $key
            case c command
                set commands $commands $value

            case d debug-level
                set debug_level $value

            case i interactive
                set mode $value

            case l login
                set mode $value

            case n no-execute
                set mode $value

            case p profile
                set flags $flags $value

            case h help
                printf "Usage: $_ [OPTIONS] [-c command] [FILE [ARGUMENTS...]]\n"
                return

            case \*
                printf "$_: '%s' is not a valid option.\n" $key
                return 1
        end
    end

    # Implementation
end
```

## NOTES

* A double dash, `--`, marks the end of options. Arguments after this sequence are placed in the default underscore key, `_`.

## AUTHORS

Jorge Bucaran <j@bucaran.me>.
