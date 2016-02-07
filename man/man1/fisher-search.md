fisher-search(1) -- Search Plugin Index
=======================================

## SYNOPSIS

fisher `search` [*plugins* ...]<br>
fisher `search` [`--name|--url|--info|--tag|--author`]<br>
fisher `search` [`--query`=*field*[`&&`,`||`]*field*...]<br>
fisher `search` [`--and`] [`--or`] [`--quiet`] [`--help`]<br>

## USAGE

fisher `search` *url*<br>
fisher `search` *name*<br>
fisher `search` *owner/repo*<br>
fisher `search` *query*<br>

## DESCRIPTION

Search plugins in the Fisherman index.

The index file consists of records separated by blank lines `'\n\n'` and each record consists of fields separated by a single line `'\n'`.

For example:

```
name
url
info
tag1 tag2 tag3 ...
author
```

See *Index* in `fisher help tour` for more information about the index.

## OPTIONS

* `--<field>[=match]`:
    Display index records where *field* equals *match*. *field* can be any of `name`, `url`, `info`, `tag/s` or `author`. If *match* is not given, display only the given *field* from every record in the index. Use `!=` to negate the query.

* `--<field>[~/regex/]`:
    Same as `--<field>[=regex]`, but using Regular Expressions instead of exact matching. Use `!~` to negate the query.

* `-a --and`:
    Join the query with a logical AND operator.

* `-o --or`:
    Join the query with a logical OR operator. This is the default operator.

* `-q --quiet`:
    Enable quiet mode.

* `-h --help`:
    Show help.

## OUTPUT

Search prints the result records in their original format by default.

```fish
fisher search shark
shark
https://github.com/bucaran/shark
Sparkline Generator
chart tool graph sparkline
bucaran
```

To allow for easier parsing, Search will print results records in the same line when using one or more of the following options: `--name`, `--url`, `--info`, `--tags`, `--author`.

```fish
fisher search shark --name --url --author

shark;https://github.com/fishery/shark;bucaran
```

The result set above consists of single line per record, and each record consists of one or more of the specified fields separated by semicolons `';'`.

## EXAMPLES

* Display plugins by name and format the result into multiple columns.

```fish
fisher search --name | column
```

* Display plugins by URL, sans *https://github.com/* and format into multiple columns.

```fish
fisher search --field=url | sed 's|https://github.com/||' | column
```

* Display remote plugins, i.e, those in the index, but *not* in the cache.

```fis
fisher_search --and --name!=(fisher --list=bare)
```

* Search all plugins whose name does not start with the letter `s`.

```fish
fisher search --name!~/^s/
```

## SEE ALSO

fisher(1)<br>
fisher help plugins<br>
