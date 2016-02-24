<a name="fisherman"></a>

<h3 align="center">
    <br>
    <a href="http://fisherman.sh">
        <img
            alt="Fisherman"
            width=650px
            src="https://rawgit.com/fisherman/logo/master/fisherman-black-white.svg"></a>
    <br>
    <br>
    <br>
</h3>

[![Build Status][travis-badge]][travis-link]
[![Fisherman Version][version-badge]][version-link]
[![Slack Room][slack-badge]][slack-link]

<hr>

**Fisherman** is a blazing fast, modern plugin manager for [Fish](http://fishshell.com/).

Features include a flat tree dependency model, a cache system, full test coverage and [more].

&nbsp; ▸ &nbsp; **[Get Started]**<br>
&nbsp; ▸ &nbsp; **[Find Plugins]**


## Performance

Fisherman runs virtually no initialization code making it as fast as no Fisherman.

```fish
time -p fish -ic exit
```

<p align="center">
    <a href="https://github.com/fisherman/fisherman/wiki/Performance">
        <img
            alt="Performance"
            width=45%
            src="https://cloud.githubusercontent.com/assets/8317250/12769643/c6e2db4e-ca5c-11e5-9f4e-7d90cd072063.png">
    </a>
</p>

See [here][performance] for the gory details.

## Documentation

For documentation and guides see the [wiki]. For questions and feedback join the Slack [room][slack-link] or browse the [issues].

[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square
[version-badge]: https://img.shields.io/badge/latest-v0.8.0-00B9FF.svg?style=flat-square
[version-link]: https://github.com/fisherman/fisherman/releases
[slack-link]: https://fisherman-wharf.herokuapp.com/
[slack-badge]: https://img.shields.io/badge/slack-join%20the%20chat-00B9FF.svg?style=flat-square

[fish]: https://github.com/fish-shell/fish-shell
[Get Started]: https://github.com/fisherman/fisherman/wiki/Quickstart-Guide
[Find Plugins]: http://fisherman.sh/#search

[performance]: https://github.com/fisherman/fisherman/wiki/Performance

[wiki]: https://github.com/fisherman/fisherman/wiki
[issues]: http://github.com/fisherman/fisherman/issues
[more]: https://github.com/fisherman/fisherman/issues/69#issuecomment-179661994
