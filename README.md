<a name="fisherman"></a>

<p align="center">
    <br>
    <a href="http://fisherman.sh">
        <img
            alt="Fisherman"
            width=660px
            src="https://rawgit.com/fisherman/logo/master/fisherman-black-white.svg">
    </a>
    <br>
    <br>
    <br>
</p>

[![Build Status][travis-badge]][travis-link]
[![Fisherman Version][version-badge]][version-link]
[![Wharf][wharf-badge]][wharf-link]

<hr>

**Fisherman** is a blazing [fast](#performance), modern plugin manager for [Fish](http://fishshell.com/).

Features include a flat tree dependency model, external self-managed index, cache mechanism, full test coverage and compatibility with Tackle, Oh My Fish! and Wahoo themes and plugins.

&nbsp; :point_right: [**Get Started**][quickstart]

## Performance

The following benchmarks were calculated using a 2.4 GHz Intel Core i5 MacBook Pro running on Flash Storage. See [Performance][performance] to learn more.

```fish
time -p fish -ic exit
```

Fisherman runs virtually no initialization code making it as fast as no Fisherman. Fundle performs well, but still [runs][fundle] cumbersome startup code. Oh My Fish! has the worst performance at `0.21` seconds for a lightweight setup.

<p align="center">
    <a href="https://github.com/fisherman/fisherman/wiki/Performance">
        <img
            alt="Performance"
            width=65%
            src="https://cloud.githubusercontent.com/assets/8317250/12769643/c6e2db4e-ca5c-11e5-9f4e-7d90cd072063.png">
        <br>
        <sup><sup>SEE MORE</sup></sup>
    </a>
</p>

## Documentation

For documentation and guides [see the wiki][wiki]. For questions and feedback join the Slack [room][wharf-link] or browse the [issues][issues].

:anchor:

<!-- Header -->

[travis-link]:      https://travis-ci.org/fisherman/fisherman
[travis-badge]:     https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square
[version-badge]:    https://img.shields.io/badge/latest-v0.7.0-00B9FF.svg?style=flat-square
[version-link]:     https://github.com/fisherman/fisherman/releases
[wharf-link]:       https://fisherman-wharf.herokuapp.com/
[wharf-badge]:      https://img.shields.io/badge/slack-join%20the%20chat-00cc99.svg?style=flat-square

<!-- About -->

[fish]:             https://github.com/fish-shell/fish-shell
[quickstart]:       https://github.com/fisherman/fisherman/wiki/Quickstart-Guide

<!-- Performance -->

[fundle]:           https://github.com/tuvistavie/fundle/blob/master/functions/fundle.fish#L232
[performance]:      https://github.com/fisherman/fisherman/wiki/Performance

<!-- Documentation -->

[wiki]:             https://github.com/fisherman/fisherman/wiki
[issues]:           http://github.com/fisherman/fisherman/issues
