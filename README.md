<a name="fisherman"></a>

<p align="center">
  <a href="http://fisherman.sh">
    <img alt="Fisherman" width=620px  src="https://cloud.githubusercontent.com/assets/8317250/10865127/daa0e138-8044-11e5-91f9-f72228974552.png">
  </a>
</p>

[![Build Status][travis-badge]][travis-link]
![Fisherman Version][fisherman-version]
[![Wharf][wharf-badge]][wharf-link]


## About

**Fisherman** is a blazing [fast](#performance), modern plugin manager for [Fish](http://fishshell.com/).


Features include a flat tree dependency model, external self-managed database, cache mechanism, great test coverage and compatibility with Tackle, Oh My Fish! and Wahoo themes and plugins.

:point_right: [**Get Started**][quickstart]

## Performance

The following benchmarks were calculated using a 2.4 GHz Intel Core i5 MacBook Pro running on Flash Storage.

```fish
time -p fish -ic exit
```

Fisherman runs virtually no initialization code making it as fast as no Fisherman. [Fundle][fundle] performs well, but still [runs][fundle-slow] cumbersome startup code. Oh My Fish! has by far the worst performance at `0.21s`.

To learn more about these benchmarks, see [Performance][performance].

<p align="center">
<img width=65% src="https://cloud.githubusercontent.com/assets/8317250/12769643/c6e2db4e-ca5c-11e5-9f4e-7d90cd072063.png"
</p>



## Documentation

For documentation and guides [see the wiki][wiki]. For questions and feedback join the Slack [room][wharf-link] or browse the [issues][issues].


:anchor:


<!-- Links -->

[faq]: https://github.com/fisherman/fisherman/wiki/FAQ
[fish]: https://github.com/fish-shell/fish-shell
[docs]: https://github.com/fisherman/fisherman/wiki
[wiki]: https://github.com/fisherman/fisherman/wiki
[index]: https://github.com/fisherman/fisher-index
[issues]: http://github.com/fisherman/fisherman/issues
[fundle]: https://github.com/tuvistavie/fundle/
[quickstart]: https://github.com/fisherman/fisherman/wiki/Quickstart-Guide
[wharf-link]: https://fisherman-wharf.herokuapp.com/
[wharf-badge]: https://img.shields.io/badge/Slack-join%20the%20chat-00cc99.svg?style=flat-square
[fundle-slow]: https://github.com/tuvistavie/fundle/blob/master/functions/fundle.fish#L232
[travis-link]: https://travis-ci.org/fisherman/fisherman
[travis-badge]: https://img.shields.io/travis/fisherman/fisherman.svg?style=flat-square
[fisherman-version]: https://img.shields.io/badge/latest-v0.5.0-00B9FF.svg?style=flat-square
[performance]: https://github.com/fisherman/fisherman/wiki/Performance
