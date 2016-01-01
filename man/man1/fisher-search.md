fisher-search(1) -- Search Fisherman Index
==========================================

## SYNOPSIS

fisher `search` [*name* or *url*]<br>
fisher `search` [`--select`=*all*|*cache*|*remote*]<br>
fisher `search` [`--field`=*name*|*url*|*info*|*tag*|*author*]<br>
fisher `search` [`--`*field*=*match*] <br>
fisher `search` [`--`*field*~`/`*regex*`/`] <br>
fisher `search` [`--query`=*field*[`&&`,`||`]*field*...]<br>
fisher `search` [`--and`] [`--or`] [`--quiet`] [`--help`]<br>

## USAGE

fisher `search` *plugin*<br>
fisher `search` *owner/repo*<br>
fisher `search` --field=*name* --select=all | column<br>
fisher `search` --tag=tag1 --and --tag=tag2

## DESCRIPTION

Search the Fisherman index database. You can use a custom index file by setting `$fisher_index` to your preferred url or file. See `fisher help config` and `fisher`(7)#{`Index`}.

A copy of the index is downloaded each time a search query happens, keeping the index up to date all the time.

The index file consists of records separated by blank lines `'\n\n'` and each record consists of fields separated by a single line `'\n'`.

```
name
url
info | description
tag1 tag2 ...
author
```

See #{`Output`} for more information.

## OPTIONS

* `-s` `--select`[=*all*|*cache*|*remote*]:
    Select record set. --select=*cache* queries only local plugins, i.e., those inside `$fisher_cache`. --select=*remote* queries all plugins not in the cache. --select=*all* queries everything.

* `-f` `--field`=*name*|*url*|*info*|*tag*|*author*:
    Display only given fields from the result record set. Use `--select` to filter the record set. Use --*field* instead as a shortcut, i.e., `--name` is equivalent to `--field`=name.

* --*field*[=*match*]:
    Filter the result set by *field*=*match*, where *field* can be any of `name`, `url`, `info`, `tag` or `author`. If *match* is not given, this is equivalent to `--select`=*field*. Use `!=` to negate the query.

* --*field*[~`/`*regex*`/`]:
    Essentially the same as --*field*=*match*, but with Regular Expression support. --*field*~`/`*regex*`/` filters the result set using the given `/`*regex*`/`. For example, --name=`/`^*match*$`/` is essentially the same as --*field*=*match* and --url~`/`oh-my-fish`/` selects only Oh My Fish! plugins.  Use `!~` to negate the query.

* `-a` `--and`:
    Join query with a logical AND operator.

* `-o` `--or`:
    Join query with a logical OR operator. This the default operator for each query operation.

* `-Q` `--query`=*field*[`&&`,`||`]*field*...:
    Use a custom search expression. For example, --query='name~`/`[0-9]`/`||name~`/`^[xyz]`/`' selects all plugins that contain numbers in their name *or* begin with the characters *x*, *y* or *z*.

* `-q` `--quiet`:
    Enable quiet mode.

* `-h` `--search`:
    Show usage search.

## OUTPUT

The default behavior is to print the result set to standard output in its original format.

```
fisher search bobthefish shark
```

`...`

```
bobthefish
https://github.com/oh-my-fish/theme-bobthefish
A Powerline-style, Git-aware fish theme optimized for awesome
theme powerline awesome
bobthecow

shark
https://github.com/bucaran/shark
Sparklines for your Fish
chart tool
bucaran
```

Search is optimized for parsing when using filters: `--name`, `--url`, `--info`, `--tags`, `--author` or `--field`=*name*|*url*|*info*|*tag*|*author*.

```
fisher search bobthefish shark --name --url
```

`...`

```
bobthefish;https://github.com/oh-my-fish/theme-bobthefish
shark;https://github.com/bucaran/shark
```

The result set above consists of single line `'\n'` separated records where each record consists of one or more of the given fields separated by a semicolon `';'`.

## EXAMPLES

Display all plugins by name and format into multiple columns.

```
fisher search --name | column
```

Display all plugins by url, sans *https://github.com/* and format into multiple columns.

```
fisher search --field=url --select=all | sed 's|https://github.com/||' | column
```

Display all remote plugins by name tagged as *a* or *b*.

```
fisher search --select=remote --name --tag=github --or --tag=tool
```

Search plugins from a list of one or more urls and / or names and display their authors.

```
fisher search $urls $names --url
```

Search all plugins in the cache whose name does not start with the letter `s`.

```
fisher search --select=cache --name~/^[^s]/
```

## SEE ALSO

`fisher`(1)<br>
`fisher`(7){`Index`}<br>
`fisher help plugins`<br>
