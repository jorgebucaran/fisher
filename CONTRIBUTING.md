[![Slack Room][slack-badge]][slack-link]

# Contributing

If you are looking for ways to help, browse [open issues][issues] or send us your PR if you are already working on something.

## Guidelines

* Fork the repo and create your feature branch from master.

* If you make significant changes, please add tests too. Get familiar with [Fishtape].

* If you've changed APIs, please update the documentation.

* Follow the [seven rules] of a great Git commit message.

## Plugins

1. Create a new plugin with `scaffold`.
```fish
fisher install scaffold
fisher scaffold
```

2. Submit a plugin to the [index] with `submit`.
```fish
fisher install submit
fisher submit my_plugin
```

## Translations

If you would like to translate a portion of the documentation, you can begin with the [Quickstart Guide].

[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square
[seven rules]: http://chris.beams.io/posts/git-commit/#seven-rules
[open issues]: https://github.com/fisherman/fisherman/issues?q=is%3Aopen+is%3Aissue
[Fishtape]: https://github.com/fisherman/fishtape
[index]: https://github.com/fisherman/fisher-index
[Quickstart Guide]: https://github.com/fisherman/fisherman/wiki/Quickstart-Guide
