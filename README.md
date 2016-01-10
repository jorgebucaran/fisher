<p align="center">
  <a href="http://github.com/fisherman/fisherman">
    <img alt="Fisherman" width=620px  src="https://cloud.githubusercontent.com/assets/8317250/10865127/daa0e138-8044-11e5-91f9-f72228974552.png">
  </a>
</p>


[![Build Status][travis-badge]][travis-link]
![Fisherman Version][fisherman-version]
[![Wharf][wharf-badge]][wharf-link]

## About

Fisherman is a plugin manager for [fish][fish] that lets you share and reuse code, prompts and configurations easily.

Features include a flat tree structure, external self-managed database, cache system, plugin dependencies and compatibility with Oh My Fish! packages.

+ See [FAQ][faq].
+ See [Screencasts][screencasts].


## Install

```fish
git clone https://github.com/fisherman/fisherman
cd fisherman
make
```

## Contributing

Check out the [contribution](CONTRIBUTING.md) guidelines.

## Help

See [`fisher(1)`][fisher-1] and [`fisher(7)`][fisher-7] for usage and documentation. For support and feedback join the Slack [room][wharf-link] or browse the [issues][issues].


:anchor:


<!-- Links -->

[fish]:              https://github.com/fish-shell/fish-shell
[faq]:               https://github.com/fisherman/fisherman/wiki/FAQ
[issues]:            http://github.com/fisherman/fisherman/issues
[wharf-link]:        https://fisherman-wharf.herokuapp.com/
[wharf-badge]:       https://img.shields.io/badge/wharf-join%20the%20chat-00cc99.svg?style=flat-square
[screencasts]:       https://github.com/fisherman/fisherman/wiki/Screencasts
[fisher-1]:          man/man1/fisher.md
[fisher-7]:          man/man7/fisher.md
[travis-link]:       https://travis-ci.org/fisherman/fisherman
[travis-badge]:      https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square
[fisherman-version]: https://img.shields.io/badge/fisherman-v0.3.1-00B9FF.svg?style=flat-square
