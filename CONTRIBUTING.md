[![Slack Room][slack-badge]][slack-link]

# Contributing to Fisherman

If you are looking for ways to help, peruse the [open issues][issues] or send us your PR if you are already working on something.

## Guidelines

* Fork the repo and create your feature branch from master.

* If you make significant changes, please add tests too. Get familiar with [Fishtape][fishtape].

* If you've changed APIs, please update the documentation.

* Follow the [seven rules][rules] of a great git commit message.

## Plugins

The fastest way to create a plugin is using the `scaffold` plugin.

1. Install

    ```fish
    fisher install scaffold
    ```

2. Create a new plugin using the default template.
    > See the `fisher help scaffold` for other usage instructions.

    ```fish
    fisher scaffold
    ```

To browse the available content use `fisher search` or browse the [Fishery][fishery].

To submit a new plugin to the [index][index], use the `submit` plugin.

1. Install

    ```fish
    fisher install submit
    ```

2. Submit

    ```fish
    fisher submit my_plugin
    ```

## Translations

If you would like to translate a portion of the documentation, you can begin with the [Quickstart Guide][quick-start]. Use any of the existing translations as a reference to get started.

<!-- Badges -->

[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square

<!-- Links -->

[rules]: http://chris.beams.io/posts/git-commit/#seven-rules
[issues]: https://github.com/fisherman/fisherman/issues?q=is%3Aopen+is%3Aissue
[fishtape]: https://github.com/fisherman/fishtape

<!-- Plugins -->

[index]: https://github.com/fisherman/fisher-index
[fishery]: https://github.com/fishery

<!-- Translations -->

[quick-start]: https://github.com/fisherman/fisherman/wiki/Quickstart-Guide
