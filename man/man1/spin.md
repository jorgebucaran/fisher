spin(1) -- Background job spinner
=================================

## SYNOPSIS

`spin` *commands* [`--style`=*mix*|*arc*|*star*|*pipe*|*flip*|*bounce*|*bar1~3*]<br>
`spin` *commands* [`--error`=file] [`--format`=format] [`--help`]

## DESCRIPTION

**Spin** is a terminal spinner and progress bar indicator for fish.

## USAGE

```fish
spin "sleep 1"
```

Spin interprets any output to standard error as failure. Use --error=*file* to redirect the standard error output to *file*.

```fish
if not spin --style=pipe --error=debug.txt "curl -sS $URL"
    return 1
end
```

## Options

* -s, --style=*style*|*string*:
    Use *string* to slice the spinner characters. If you don't want to display the spinners, use --style=*""*.

* -f, --format=*format*:
    Use *format* to customize the spinner display. The default format is `"  @\r"` where `@` represents the spinner token and `\r` a carriage return, used to refresh (erase) the line.

* --error=*file*:
    Write the standard error output to a given *file*.

* -h, --help:
    Show usage help.

### Customization

Replace the default spinner with your own string of characters. For example, --style=*12345* will display the numbers from 1 to 5, and --style=*.* --format=*@* an increasing sequence of dots.
