fisher-search(1) -- Search plugin index
=======================================

## SYNOPSIS

fisher search [*plugins* ...]<br>
fisher search [--name|--url|--info|--tag|--author]<br>
fisher search [--and] [--or] [--quiet] [--help]<br>
fisher search [--long|--full] [--no-color]<br>
fisher search [--query=*field*[&&,||]*field*...]<br>

## USAGE

fisher search *url*<br>
fisher search *name*<br>
fisher search *owner/repo*<br>
fisher search *query*<br>

## DESCRIPTION

Search plugins in the Fisherman index.

```
fisher search
  ...
* debug        Conditional debug logger
  errno        POSIX error code/string translator
* fishtape     TAP producing test runner
  flash        Flash-inspired, thunder prompt
  fzf          Efficient keybindings for fzf
  get          Press any key to continue
  ...
> shellder     Powerline prompt optimized for speed
  ...
```

Get detailed information about a plugin.

```
fisher search shellder
> shellder by simnalamburt
Powerline prompt optimized for speed
github.com/simnalamburt/shellder
```

Search plugins using tags.

```
fisher search --tag={git,test}
  ...
* fishtape           TAP producing test runner
  git-branch-name    Get the name of the current Git branch
  git-is-repo        Test if the current directory is a Git repo
  git-is-dirty       Test if there are changes not staged for commit
  git-is-stashed     Test if there are changes in the stash
  ...
```

The legend consists of:

`*` Indicate the plugin is currently installed<br>
`>` Indicate the plugin is a prompt<br>
`@` Indicate the plugin is a symbolic link<br>

## OPTIONS

* --*field*[=*match*]:
    Display index records where *field* equals *match*. *field* can be any of name, url, info, tag/s or author. If *match* is not given, display only the given *field* from every record in the index. Use != to negate the query.

* --*field*[~/regex/]:
    Same as --*field*[=*match*], but using Regular Expressions. Use !~ to negate the query.

* --long:
    Display results in long format.

* --full:
    Display results in full format.

* --no-color:
    Turn off color display.

* -a, --and:
    Join the query with a logical AND operator.

* -o, --or:
    Join the query with a logical OR operator. This is the default operator.

* -q, --quiet:
    Enable quiet mode.

* -h, --help:
    Show help.

## RESULTS

Search prints results records in the same line, when using one or more of the following options: --name, --url, --info, --tags, --author. This allows you to parse search results easily.

```fish
fisher search shark --name --url --author

shark;https://github.com/fishery/shark;bucaran
```

## EXAMPLES

* Display plugins by name and format the result into multiple columns.

```fish
fisher search --name | column
```

* Display plugins by URL, remove *https://github.com/* and format into multiple columns.

```fish
fisher search --url | sed 's|https://github.com/||' | column
```

* Display remote plugins, i.e, those in the index, but *not* in the cache.

```fish
fisher search --and --name!=(fisher --list=bare)
```

* Search all plugins whose name does not start with the letter s.

```fish
fisher search --name!~/^s/
```
