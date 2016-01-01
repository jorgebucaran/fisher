wait(1) -- Run commands and wait with a spin
============================================

## SYNOPSIS

`wait` *commands* [`--spin`=*arc*|*star*|*pipe*|*ball*|*flip*|*mixer*|*caret*|*bar1~3*]<br>
`wait` *commands* [`--time`=interval] [`--log`=file] [`--format`=format] [`--help`]

## DESCRIPTION

Run *commands* as a background process and wait until the job has finished. Any output to standard error indicates `wait` to return `1` once is done. While it waits, a customizable spinner is displayed in the command line.

## OPTIONS

* `-s`, `--spin`=*style*|*string*:
    Set spinner style. See #{Styles} for a list of styles and instructions on how to use your own character sequences, progress bar usage, etc.

* `-t` `--time`=*interval*:
    Set spinner transition time delay in *seconds*. A large value will refresh the spinner more slowly. You may use decimal numbers to represent smaller numbers.

* `-l` `--log`=*file*:
    Output standard error to given *file*.

* `-f` `--format`=*format*:
    Use given *format* to display the spinner. The default format is `"\r@"` where `@` represents the spinner token and `\r` a carriage return, used to refresh / erase the line.

* `-h` `--help`:
    Show usage help.

## STYLES

The following styles are supported via `--spin=`*style*:

* arc, star, pipe, ball, flip, mixer, caret
* bar1~3

### CUSTOMIZATION

In addition to the default styles, you can specify a string of character tokens to be used each per spinner refresh cycle.

For example `--spin=12345` will display the numbers from 1 to 5, and `--spin=. --format=@` an increasing sequence of dots.

### PROGRESS BARS

Display a progress bar with a percent indicator using `--spin`=*bar1~3*:

* bar1: [=====] *num*%
* bar2: [#####] *num*%
* bar3: ....... *num*%

You can customize the appearance as follows:

```
--spin=bar:<opening token><fill token><empty slot token><closing token>[%]
```

For example:

```
--spin="bar:[+-]%"
--spin="bar:(@o)"
--spin="bar:||_|"
```

## EXAMPLES

Run a lengthy operation as a background job and display a spinning pipe character until it is finished.

```
wait --spin=pipe "curl -sS $url"
```

Output any errors to *debug.txt*.

```
if not wait --spin=pipe --log=debug.txt "curl -sS $url"
    return 1
end
```

## AUTHORS

Jorge Bucaran *j@bucaran.me*.


## SEE ALSO

`sleep`(1)<br>
`help introduction`#{`Background Jobs`}<br>
