fisher-search(1) -- Search Plugin Index
==========================================

## SYNOPSIS

fisher `search` [*plugins* ...]<br>
fisher `search` [`--select`=*all*|*cache*|*remote*]<br>
fisher `search` [`--field`=*name*|*url*|*info*|*tag*|*author*]<br>
fisher `search` [`--`*field[*=*match*]] <br>
fisher `search` [`--`*field*~`/`*regex*`/`] <br>
fisher `search` [`--query`=*field*[`&&`,`||`]*field*...]<br>
fisher `search` [`--and`] [`--or`] [`--quiet`] [`--help`]<br>

## USAGE

fisher `search` *plugin*<br>
fisher `search` *owner/repo*<br>

## DESCRIPTION

Search the Fisherman index database. You can use a custom index file by setting `$fisher_index` to your preferred URL or file. See `fisher help config` and *Index* in `fisher help tour`.

A copy of the index is downloaded every time a search query happens, keeping the index up to date all the time.

The index file consists of records separated by blank lines `'\n\n'` and each record consists of fields separated by a single line `'\n'`.

For example:

```
name
url
info
tag1 tag2 tag3 ...
author
```

See *Output* for more information.

## OPTIONS

* `-s --select[=all|cache|remote]`:
    Select the record source. --select=*cache* queries only local plugins, i.e., those inside `$fisher_cache`. --select=*remote* queries all plugins not in the cache, i.e, those available to install. --select=*all* queries everything.

* `-f --field=name|url|info|tag|author`:
    Display only the given fields from the selected records. Use --*field* as a shortcut for --field=*field*. For example `fisher search --url` will display only the URLs for

* `--field[=match]`:
    Filter the result set by *field*=*match*, where *field* can be one or more of `name`, `url`, `info`, `tag` or `author`. If *match* is not given, this is equivalent to --select=*field*. Use `!=` to negate the query.

* `--field[~/regex/]`:
    Essentially the same as --*field*=*match*, but with Regular Expression support. --*field*~/*regex*/ filters the result set using the given /*regex*/. For example, --name=/^*match*$/ is the same as --*field*=*match* and --url~/oh-my-fish/ selects only oh-my-fish plugins.  Use `!~` to negate the query.

* `-a --and`:
    Join query with the logical AND operator.

* `-o --or`:
    Join query with the logical OR operator. This the default operator for each query.

* `-Q --query=field[&&,||]field...`:
    Use a custom search expression. For example, `--query=name~/[0-9]/||name~/^[xyz]/` selects all plugins that contain numbers in their name *or* begin with the characters *x*, *y* or *z*.

* `-q --quiet`:
    Enable quiet mode.

* `-h --search`:
    Show help.

## OUTPUT

The default behavior is to print the result set to standard output in their original format.

```
fisher search shark
shark
https://github.com/bucaran/shark
Sparkline Generator
chart tool
bucaran
```

Search is optimized for parsing when using the filters: `--name`, `--url`, `--info`, `--tags`, `--author` or `--field=name|url|info|tag|author`.

```
fisher search shark --name --url

shark;https://github.com/bucaran/shark
```

The result set above consists of single line `'\n'` separated records, and each record consists of one or more of the given fields separated by a semicolon `';'`.

## EXAMPLES

* Display all plugins by name and format into multiple columns.

```
fisher search --name | column
```

* Display all plugins by URL, sans *https://github.com/* and format into multiple columns.

```
fisher search --field=url --select=all | sed 's|https://github.com/||' | column
```

* Display all remote plugins by name tagged as *a* or *b*.

```
fisher search --select=remote --name --tag=github --or --tag=tool
```

* Search plugins from a list of one or more urls and / or names and display their authors.

```
fisher search $urls $names --url
```

* Search all plugins in the cache whose name does not start with the letter `s`.

```
fisher search --select=cache --name~/^[^s]/
```

## SEE ALSO

fisher(1)<br>
fisher help plugins<br>
