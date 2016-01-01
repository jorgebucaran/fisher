getopts(1) -- Parse CLI options
===============================

## SYNOPSIS

`getopts` [*options* ...]<br>
`getopts` [*options* ...] `|` `while` read -l key value; ...; `end`<br>

## DESCRIPTION

getopts is a tool to help parsing command-line arguments. It is designed to process command line arguments that follow the POSIX Utility Syntax Guidelines. If no arguments are given it returns `1`.

## USAGE

In the following example:

```
getopts -ab1 --foo=bar baz
```

And its output:

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

## OPTIONS

None.

## EXAMPLES

The following is a mock of `fish`(1) CLI missing the implementation:

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
                printf "usage: $_ [OPTIONS] [-c command] [FILE [ARGUMENTS...]]\n"
                return

            case \*
                printf "$_: '%s' is not a valid option.\n" $key
                return 1
        end
    end

    # Implementation
end
```

## BUGS

* getopts does *not* read the standard input. Use getopts to collect options and the standard input to process a stream of data relevant to your program.

* A double dash, `--`, marks the end of options. Arguments after this sequence are placed in the default underscore key, `_`.

* The getopts described in this document is *not* equivalent to the getopts *builtin* found in other shells. This tool is only available for `fish`(1).

## AUTHORS

Jorge Bucaran <j@bucaran.me>.

## SEE ALSO

POSIX Utility Syntax Guidelines [goo.gl/yrgQn9]<br>
