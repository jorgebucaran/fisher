getopts(1) -- Command line options parser
=========================================

## SYNOPSIS

getopts *options* ...<br>

## DESCRIPTION

**Getopts** is a command line options parser for fish.

## USAGE

Study the output of the following example

```
getopts -ab1 --foo=bar baz
```

```
a
b    1
foo  bar
_    baz
```

The items on the left are the option flags. The items on the right are the option values. The underscore `_` character is the default *key* for bare arguments.

Use read(1) to process the generated stream and switch(1) to match patterns

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

## NOTES

* A double dash, `--`, marks the end of options. Arguments after this sequence are placed in the default underscore key, `_`.
