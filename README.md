<p align="center">
  <a href="http://github.com/fisherman/fisherman">
    <img alt="Fisherman" width=620px  src="https://cloud.githubusercontent.com/assets/8317250/10865127/daa0e138-8044-11e5-91f9-f72228974552.png">
  </a>
</p>


[![Build Status][travis-badge]][travis-link]
![Fisherman Version][fisherman-version]

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
fisher help
```

## Contributing

Check out the [contribution](CONTRIBUTING.md) guidelines.

## Help

See [`fisherman(1)`][fisherman-1] and [`fisherman(7)`][fisherman-7] for usage and documentation. For support and feedback join the Gitter [room][wharf] or browse the [issues][issues].


:anchor:


<!-- Links -->

[fish]:              https://github.com/fish-shell/fish-shell
[faq]:               https://github.com/fisherman/fisherman/wiki/FAQ
[issues]:            http://github.com/fisherman/fisherman/issues
[wharf]:             https://gitter.im/fisherman/wharf
[screencasts]:       https://github.com/fisherman/fisherman/wiki/Screencasts
[fisherman-1]:       man/man1/fisher.md
[fisherman-7]:       man/man7/fisher.md
[travis-link]:       https://travis-ci.org/fisherman/fisherman
[travis-badge]:      https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square
[fisherman-version]: https://img.shields.io/badge/fisherman-v0.1.0-00B9FF.svg?style=flat-square
