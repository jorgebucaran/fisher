<p align="center">
  <a href="http://fisherman.sh">
    <img alt="Fisherman" width=620px  src="https://cloud.githubusercontent.com/assets/8317250/10865127/daa0e138-8044-11e5-91f9-f72228974552.png">
  </a>
</p>

[![Build Status][travis-badge]][travis-link]
![Fisherman Version][fisherman-version]
[![Wharf][wharf-badge]][wharf-link]

## About

Fisherman is a plugin manager and CLI toolkit for [Fish][fish] to help you build powerful utilities and share your code easily.

Fisherman uses a [flat tree][flat-tree] structure that adds no cruft to your shell, making it as fast as no Fisherman. The cache mechanism lets you query the index offline and enable or disable plugins as you wish.

Other features include dependency management, great plugin search capabilities and full compatibility with [Tackle][tackle], [Wahoo][wahoo] and [oh-my-fish][oh-my-fish] themes and packages.

+ [FAQ][faq]
+ [Screencasts][screencasts]
+ [An Introduction to Fisherman][intro]


## Install

```fish
git clone https://github.com/fisherman/fisherman
cd fisherman
make
```


## Documentation

See [`fisher help`][fisher-1] and [`fisher help tour`][fisher-tour] for command usage help. For support and feedback join the Slack [room][wharf-link] or browse the [issues][issues].


:anchor:


<!-- Links -->

[faq]: https://github.com/fisherman/fisherman/wiki/FAQ
[fish]: https://github.com/fish-shell/fish-shell
[intro]: ...
[wahoo]: https://github.com/bucaran/wahoo
[issues]: http://github.com/fisherman/fisherman/issues
[tackle]: https://github.com/justinmayer/tackle
[fisher-1]: man/man1/fisher.md
[flat-tree]: https://github.com/fisherman/fisherman/blob/master/man/man7/fisher.md#flat-tree
[oh-my-fish]: https://github.com/oh-my-fish/oh-my-fish/
[wharf-link]: https://fisherman-wharf.herokuapp.com/
[fisher-tour]: man/man7/fisher.md
[wharf-badge]: https://img.shields.io/badge/wharf-join%20the%20chat-00cc99.svg?style=flat-square
[screencasts]: https://github.com/fisherman/fisherman/wiki/Screencasts
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square
[fisherman-version]: https://img.shields.io/badge/fisherman-v0.3.1-00B9FF.svg?style=flat-square
