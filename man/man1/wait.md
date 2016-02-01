wait(1) -- Run commands and wait with a spin
============================================

## SYNOPSIS

`wait` *commands* [`--spin`=*arc*|*star*|*pipe*|*ball*|*flip*|*mixer*|*caret*|*bar1~3*]<br>
`wait` *commands* [`--time`=interval] [`--log`=file] [`--format`=format] [`--help`]

## DESCRIPTION

Run *commands* as a background process and wait until the job has finished. Any output to standard error indicates `wait` to return `1` once is done. While it waits, a customizable spinner is displayed in the command line.

## OPTIONS

* `-s --spin=style|string`:
    Set spinner style. See `Styles` for styles and details to customize the spinner characters.

* `-t --time=interval`:
    Set spinner transition time delay in *seconds*. A large value will refresh the spinner more slowly. You may use decimal numbers to represent smaller numbers.

* `-l --log=file`:
    Output standard error to given *file*.

* `-f --format=format`:
    Use given *format* to display the spinner. The default format is `"\r@"` where `@` represents the spinner token and `\r` a carriage return, used to refresh / erase the line.

* `-h --help`:
    Show usage help.

## STYLES

* arc, star, pipe, ball, flip, mixer, caret
* bar1~3

If no style is given in `--spin=<style>`, `mixer` is used by default. If you don't want to display any spinners, use `--spin=""`.

### CUSTOMIZATION

In addition to the default styles, you can specify a string of character tokens to be used each per spinner refresh cycle.

For example `--spin=12345` will display the numbers from 1 to 5, and `--spin=. --format=@` an increasing sequence of dots and `@` represents the spinner character.

### PROGRESS BARS

Display a progress bar with a percent indicator using `--spin=bar1~3`:

* bar1: [=====] *num*%
* bar2: [#####] *num*%
* bar3: ....... *num*%

## EXAMPLES

Run a lengthy operation as a background job and display a spinning pipe character until it is finished.

```
wait --spin=pipe "curl -sS $URL"
```

Output any errors to *debug.txt*.

```
if not wait --spin=pipe --log=debug.txt "curl -sS $URL"
    return 1
end
```

## SEE ALSO

sleep(1)<br>
