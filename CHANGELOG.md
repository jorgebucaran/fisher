# Change Log

## [1.0.0][v100] - 2016-03-01

* Deprecate fisher --list in favor of a new command fisher list. The behavior is roughly the same. See fisher help list for usage. tl;dr: Use list to query the local system / cache and search to query the index.

  ![](https://cloud.githubusercontent.com/assets/8317250/13388099/8973fbe0-df00-11e5-95c8-4bbb0e7172ae.gif)

* Teach fisher_plugin_walk about fish_postexec, fish_command_not_found and fish_preexec event emitters and erase them during uninstall if they were defined in a snippet.

* Fisherman now recognizes the following aliases by default: *i* for install, *u* for update, *l* for list, *s* for search and *h* for help.

* Rewrite documentation to be simpler and more consistent.

* Fisherman can install "functions" now. If you have created a function interactively, you can run fisher install `name of the function` and a directory will be created in `$PWD/name of the function` and installed as usual.

  ![](https://cloud.githubusercontent.com/assets/8317250/13421665/14e73e12-dfd3-11e5-98a5-88b269ebddd7.gif)

* Fisherman now detects if users have modified their fish prompt using fish_config and if so, uninstalls $fisher_prompt.

* Search results now truncate plugin descriptions based in the width of the terminal screen.

  ![](https://cloud.githubusercontent.com/assets/8317250/13421733/8885c65e-dfd3-11e5-84f0-e70065b55f70.gif)

* Install/Update/Uninstall CLI was retouched.

  ![cli](https://cloud.githubusercontent.com/assets/8317250/13421788/d3d873c2-dfd3-11e5-9a74-24483d29b6ff.gif)


## [0.9.0][v090] - 2016-02-25

* Welcome aboard @jethrokuan, the newest Fisherman organization member.

* The Quickstart Guide is now available in [Chinese](https://github.com/fisherman/fisherman/wiki/快速上手指南), [Russian](https://github.com/fisherman/fisherman/wiki/Краткое-Руководство) and [Korean](https://github.com/fisherman/fisherman/wiki/빠르게-살펴보기). Thanks @pickfire, @denji, @dfdgsdfg.

* Search now has a color display mode enabled by default when listing records for human consumption, but continues to produce easy to parse output when selecting specific fields.

  The following fisher search --name, fisher search --url, fisher search --name --url, fisher search --tag=prompt --name, and so forth continue to display easy to parse output.

  Queries like fisher search, fisher search --name=fishtape, fisher search --tag=prompt, fisher search --author=joe now display in color by default and support multiple formats using --format described below. The colors used are selected fromm $fish_color_* variables for best results.

  To disable color output, use --no-color. To customize the display format use any of the following keywords:

  * --format=*oneline* (default)
  * --format=*short*
  * --format=*verbose*
  * --format=*longline*
  * --format=*raw*

  ![](https://cloud.githubusercontent.com/assets/8317250/13346476/e477ad56-dca9-11e5-8b73-3546fa517057.gif)

* Search now shows unique records when listing --authors only. #128

* Update plugins with merge conflicts by fetching HEAD and applying a hard reset as a last resort. This strategy is only executed on the master branch, other branches are not affected. If branch my-feature is checked out at the time of the update, Fisherman first saves the branch name, checks out master, updates and checks out my-feature again after the operation is complete. #122.

* Update plugins with a dirty working tree by recording changes in the stash and re-reapplying them again after the git-pull update strategy completes.

* Improve fisher_name name resolution from paths or URLs accurately. Process names paths such as fisher-plugin-, fisher-theme- as well as other permutations.

* Make fisher_key_bindings_undo support more complex bind expressions, such as those inside conditional statements. #121.

* Add more consistent instrumentation / logs.

* Fix bugs caused by debug calls inside plumbing functions such as fisher_index_update.

## [0.8.0][v080] - 2016-02-20

* Welcome aboard @pickfire, the newest Fisherman organization member.

* Add instrumentation using [debug](https://github.com/fishery/debug). To enable log display add to your config.fish or set at the commandline:

    ```fish
    set -g fish_debug # or set -gx fish_debug
    ```

    The default behavior is to log everything. To filter a specific set of logs add one or more keywords to the fish_debug variable.

    ```fish
    set -gx fish_debug fisher_{install,uninstall}
    ```

    The above will show logs for fisher_install and fisher_uninstsall only. To see what other options are available, see the [documentation](https://github.com/fishery/debug).

* **Rewrite** the Fisherman installer with a new and improved look and added a TRY_ME mode in which Fisherman is not installed and the installer explains what will be run in the user's machine.

    ![Installing Fisherman](https://cloud.githubusercontent.com/assets/8317250/13040276/5f0e5350-d3ed-11e5-8994-3488f80c6494.gif)

* **Rename** core function wait to spin to reflect usage more accurately and updated its usage across Fisherman accordingly.

* **Remove** scripts directory in favor of using a functions or the root directory for sharing scripts. Using a scripts directory does not solve the main problem of sharing scripts with the same name, so this addition was deemed of little value. In the future, a more robust way to avoid name collisions when sharing scripts would be nice to have, but at the moment having a scripts directory is not solving this problem but just adding clutter to the configuration. #105.

* **Update** [website](http://fisherman.sh) to use the new SVG logo. Improve wording. Drop some hardly ever used *.favicons* and switch from SourceCodePro to Monaco style monospace fonts that will load faster as we don't have to include the font sources.

* **Rename** $fisher_key_bindings variable to $fisher_binds because it's shorter to type and makes config.fish look neater.

* **Add** user configuration before sourcing Fisherman configuration. #104.

## [0.7.0][v070] - 2016-02-11

* Welcome aboard @daenney, the newest Fisherman organization member. If you want to be part of the organization just let [me](https://github.com/bucaran) or @daenney know.

* Add the ability to install plugins from Gists. You can distribute a very simple, one-single function plugin in the form of a Gist. Your users can install it using fisher install url and Fisherman will query the Gist using the GitHub API to get a list of the Gist files and use the name of the first identified *.fish* file to name the plugin in your system. Since there is no formal way to _name_ a Gist, and you may prefer to keep the "description" field for the actual description and not a name, Fisherman supports only one fish file per Gist. #75.

* Use command(1) when calling non-builtins. Thanks @daenney. #79.

* Add fisher_plugin_can_enable to detect installing a prompt that is not the current one. #78.

* Remove the ability to install a plugin in a parent directory using .. or ../ or even worse, ../../ as well as other combinations that navigate to a parent directory. I find the use case odd at best, and more dangerous that useful. If you want to install a local plugin use the full path or a relative path, always top down. fisher install . or fisher install my/plugin or fisher install /Users/$USER/path/to/plugin. #81.

## [0.6.0][v060] - 2016-02-07

* Remove definition of $fisher_index from Fisherman's config.fish. Mostly due to cosmetic reasons and because I would like to isolate the use of the official URL into fisher_index_update alone. You can still redefine this variable and your setting will be favored over the default of 5 second timeout. In addition, fisher_index_update can also take timeout argument that shadows $fisher_timeout. This change is to "guarantee" an index update in some critical cases, for example, downloading the index for the first time should wait as needed in order to make sure Fisherman is installed.

* Revise the documentation, improve words and grammar. Remove deprecated information, add new API information. Begin to employ a more consistent writing style across manual pages.

* Fix bug in fisher_plugin_walk that was not generating the correct output for plugin completions.

* Added new plugin decorator | for plugins that are symbolic links to local projects. These plugins are those installed like fisher install path/to/local/plugin.

* Improve Install/Update/Uninstall message channels. Before everything, both errors and success information was sent to stderr. Now, the total number of plugins installed/updated/uninstalled is sent to stdout allowing us to parse this output and implement a more robust (and simpler) fisher_deps_install.

* Add new fisher_plugin_source function to allow plugins to tap into the install mechanism and provider additional features. For example, [autoinit](https://github.com/fishery/autoinit) adds init event support to Fisherman.

* Tweak validate regex to correctly handle plugins that could be named bb, gh, gl or omf.

* **spin.fish** Add a single " " space after spinner by default. To remove the white space use a format like --format="@\r".

* Supress unwated error message when the cache is empty. #66.

* Add temporary upgrade check to warn users upgrading from < 5.0

* Create empty fishfile during make install.

## [0.5.0][v050] - 2016-02-02

* **Add user key bindings support.** (#42).

  Recall $fisher_home/functions are always before user functions in $fish_function_path. This was an early design decision in order to prevent users from redefining core functions by mistake or by means other than using plugins (recommended). In other words, you are free to create a plugin that modifies a Fisherman core function, but you can't redefine a Fisherman function privately by saving it to your user config fish. If you found a bug in a Fisherman function, instead of creating a private patch send it upstream. If you created a function that overrides a Fisherman core feature, create a plugin. This way the community can benefit from your code whenever you are ready to publish it.

  By default, Fisherman provides no fish_user_key_bindings, so if the user has already defined their own fish_user_key_bindings that one will not be affected.

  Now, plugins **can** define their own key bindings inside a fish_user_key_bindings.fish *or* key_bindings.fish at the root of their repository or inside a functions directory. You can put your key bindings inside a function or not. If you put it inside a function, the function name **must** be the same as the file without the .fish extension.

  + $fisher_config/bindings.fish

  When a plugin with key bindings is installed for the first time or the only one with bindings is uninstalled, Fisherman will modify ~/.config/functions/fish_user_key_bindings.fish (or create it for the first time) and add a single line at the top of the fish_user_key_bindings function to source the new **$fisher_config/bindings.fish**. All the key bindings defined by the enabled/installed plugins are concatenated and saved to this file.

  This mechanism has the following **advantages**:

    * Does not slow down shell start.
    * Does not require Fisherman to provide his own fish_user_key_bindings by default.
    * Honors any previously existing user key bindings.
    * Allows plugin to define their own key bindings and coexist with the user's key bindings.
    * If the user updates his fish_user_key_bindings, re-running the function **does** update the key bindings.

* **Mega Refactoring**

  + The entire source code of Fisherman received a major revision and refactoring. The validation and install/uninstall mechanisms were thoroughly revised and and broken down into smaller functions easier to test as well as several other sub parts of the system.

  + Rewrite fisher search and remove features that are mostly already covered by fisher --list and remove the ability to generate information about plugins of unknown origin. The decision to **remove this feature** was based in performance concerns and the result of thinking about the usability and whether it was really worth the speed tradeoff. The conclusion is I would rather have better performance and if I need to query a plugins origin I can always use fisher --list or fisher --list=url or fisher --list=author.

  + Add $fisher_update_interval to determine if the index should update or not when a search query is taking place. The default value is 10 seconds. This means the index will *not* be updated if less than 10 seconds have elapsed since the last action that triggered an update in the first place. #43.

  + Improve Install/Uninstall/Update status output. If a plugin fails to install decrease the total. If any plugins are skipped because they are already installed in the case of fisher install or available in the cache, but disabled in the case of fisher uninstall they are collected into an array and displayed in a new section n plugin/s skipped (a, b, c) at the bottom of the report.

* **Improve test coverage.**

  + Tightly coupled functions were making testing increasingly difficult. Most of the test effort was basically testing whether git clone or git pull. New separation of concerns makes tests run faster and the difficult install/uninstall algorithms has better coverage now.

* **Other**

  + Now fisher_list can list plugins from the _cache_, a _fishfile/bundle_ and plugins that are _installed/enabled_ or _disabled_. This removes fisher_file and combines it with fisher_list. This also removes fisher -f and replaces it with fisher -l <file> or fisher --list=<file>.

    > fisher --list was replaced by fisher list

  + Rename fisher_parse_help to fisher_complete and have the function create the completions automatically. This allows you to complete your commands with parseable usage help faster. The original design was fine, but this change improves auto-complete performance so it was preferred.

  + Use fisher_index_update when building file with Make. This helps prevent an error when using a fish version < 2.2.0. #55 #50 #48.

  + Add fisher_index_update to update the index and remove previously undocumented fisher update --index. This function is designed to bypass GitHub's server network cache passing an arbitrary query string to curl like $fisher_index?RANDOM_NUMBER. This means index updates are immediately available now.

  + Add fisher --list=url option to display local plugin url or path.

  + Add fisher --list=bare option to display local plugins in the cache without the * enabled symbol.

  + Prepend > to the currently enabled theme when using fisher --list[=cache]. Related #49.

  + Prepend * to plugin names to indicate they are currently enabled when using fisher --list[=cache]. #49.

## [0.4.0][v040] - 2016-01-11

* Introducing Fisherman's official website, hosted by GitHub pages.

&emsp;&emsp; [**http://fisherman.sh**](http://fisherman.sh)


* Refactor fisher install / fisher uninstall by extracting the logic to enable / disable plugins into fisher_plugin_enable. The algorithm to enable/disable plugins is essentially the same. The only difference is _enable_, copies/symlinks files and disable removes them from $fisher_config/.... #45.

* Add support for legacy Oh My Fish! plugins using .load initialization files. #35.

* Add support for [Tackle](https://github.com/justinmayer/tackle) Fish framework initialization modules. #35.

* :gem: :snake: :camel: :penguin: Add support for plugins that share scripts in languages like Python or Perl. For example oh-my-fish/plugin-vi-mode assumes there is a vi-mode-impl.py file in the same path of the running script. This opens the door for including code snippets in other languages.

* Any py, rb, php, pl, awk or sed files at the root level of a plugin repository, or inside the functions or the new _scripts_ directory are copied to $fisher_config/functions or $fisher_config/scripts.

* Remove ad-hoc debug d function created by mistake in the Fisherman config.fish file. #34.

* Remove almost useless fisher --alias. You can still create aliases using $fisher_alias. It's difficult to add auto-complete to this feature, and even if we do so, it is slow.

* Fix bug introduced in the previous release caused by swapping the lines that calculate the index of the current plugin being installed/updated/uninstalled and the line that displays the value, causing the CLI to show incorrect values. #36. Thanks @kballard

* Add cache, enabled and disabled options to fisher --list. Now you can type fisher -l enabled to get a list of what plugins are currently enabled.

* Add new $fisher_plugins universal variable to keep track of what plugins are enabled / disabled.

* Update completions after a plugin is installed, updated or uninstalled.

* Improve autocomplete speed by removing the descriptions from plugins installed with custom URLs.

* fisher --list displays nothing and returns 1 when there are no plugins installed. #38.

* fisher uninstall does not attempt to uninstall plugins already disabled by looking at the $fisher_plugins array. --force will bypass this. #40

## [0.3.1][v031] - 2016-01-10

> This patch contains several amends for 0.3.0 and other minor documentation corrections.

* Major documentation revision and rewrite.

* fisher help shows fisher(1) by default now.

* Fix a critical bug that was causing fisher uninstall --force to remove _not_ the symbolic link, but the actual files. #24

* Rename orphan tag to custom for plugins installed using a custom URL.

* Remove fisher --link flag and create symbolic links by default for local paths. The user does not have to worry about symbolic links or whether the copy is as symbolic link or not anymore. If the user tries to install a local path, then the best thing to do is to create a symbolic link. This also eliminates the need to call update.

* Remove fisher --cache and fisher --validate. Now, that these options are separated into their own function and they are intentionally private, there is no need for them.

## [0.3.0][v030] - 2016-01-08

> This release contains several breaking changes a few major improvements. The good news is that the API is starting to look more stable and very unlikely to change drastically again in the future.

### Fixes

* Fix a critical bug in the Makefile that was incorrectly merging any existing user configuration file and the generated Fisherman configuration. #21.

* Fix a bug in install and uninstall that was adding plugin names to fishfiles instead of the URL when interacting with custom URLs. Probably closes #23.

* Fix a bug in install, update and uninstall that was displaying an incorrect plugin count if there was at least on failure.

* Fix bug in fisher install that causes install to fail even though it succeeds, due to spin(1)'s behavior of returning 1 if there is any output to standard error. #20.

* Fix bug in fisher uninstall that was removing plugins from the cache by mistake.

### Add

* Add feature to Makefile to download the index for the first time in order to provide auto-complete before the user can install/update/search, actions which would case the index to be updated.

* Add link to Slack [room](http://fisherman-wharf.herokuapp.com/) in README. Thanks @simnalamburt.

* Add new $fisher_timeout configuration variable that lets you specify curl(1) --max-time option. Without this, curl could hang for a long time if you are in a bad connection.

* Add fisher install --link to allow installing plugins creating a symbolic link to each of the relevant files to be copied during the install process. If you use --link to install a plugin that is a _path to a directory_ or file, a symbolic link to the directory will be created making local testing more convenient as you are not required to update the plugin's repository to test changes within Fisherman. If you are testing using [Fishtape](https://github.com/fisherman/fishtape) you do not even need to reset the shell session.

* ~~Add fisher --alias[=<command>=<alias>] to simplify creating new aliases for fisher commands. Use fisher --alias without arguments to list the current set of aliases. Also add auto-complete for aliases to install, update or uninstall. Note that aliases are **not** persisted this way. To save your aliases use $fisher_alias as described in fisher help config. Also note that aliases are only auto-complete if you call fisher --alias. To auto-complete aliases saved to $fisher_alias you can do fisher --alias (fisher --alias).~~

* Add short options for new and old fisher flags:

    * --file → -f
    * --list → -l
    * --alias → -a

### Improvements

* Improve help message for failed installs. ##24. @namandistro

* Improve fisher --validate to automatically correct common misspellings, for example when installing a Oh My Fish! package, one often types ohmyifsh.

* :point_up: Improve auto-complete performance by extracting the implementation of the different fisher flags to fisher_* functions. completions/fisher.fish relies heavily in fisher_search to query what plugins are available to install/update/uninstall. In this process, numerous calls to fisher --list and fisher --validate, etc., are made. Now, auto-complete does not have to pay the penalty of entering fisher, parsing options, etc. #27. @namandistro

* Improve fisher --help output and show up until now poorly documented --list, --file, etc. flags consistently. Also display available commands after make install to improve usability.

* Improve fisher install so that it checks whether the plugin you are trying to install, if it is already in the cache, is a symbolic link or not, and installs it as if the --link flag was specified.

* Improve fisher --validate to retrieve the absolute path to the closest directory of the given items if they are valid local paths. Related #19.

* Improve install to not git clone local plugins if a regular path/to/file is given to fisher install. Instead, copy to the cache using cp(1) and if --link is used, create a symlink.

* Improve fisher --validate to invalidate items with repeated . and - and allow items that begin with / or ./ to support installing plugins from local paths. Related #19.

## Remove / Rename

* Modify fisher update default behavior. Now this command updates Fisherman by default. Use of --self and --me is also **deprecated**. To read from the standard input use a dash -. For example: fisher --list | fisher update -. See [Usage of dash in place of a filename](http://unix.stackexchange.com/questions/16357/usage-of-dash-in-place-of-a-filename/16364#16364). #25.

* Rename --cache to more descriptive --list. Thanks @colstrom.

* Remove fisher --cache=base and make it return the base names of all directories in the path by default. To get the full path use printf printf "$fisher_cache/%s" (fisher --list)

* ~~Rename undocumented fisher --translate flag (again) to fisher --cache. This function reads the standard input for a name, URL or local path and calculates the plugin's path relative to the cache. For a name this is simple $fisher_cache/<name>` for an URL, retrieve the remote URL of every repository until there is a match with the given URL and return the path in the cache of that repository. Finally, if the input is a local path of the form file:/// it will pass it as is.~~

* Revert #3. The reason getopts.fish was in its own file originally is because @bucaran wanted a standalone, dependency free cli parser solution, arguably slightly faster than having Awk read getopts.awk for each use. The performance improvement is negligible at best, but getopts is also used by every single command and future commands and plugins are very likely to use it as well, so we might as well use the slightly faster version.

## [0.2.0][v020] - 2016-01-05

* Improve README, added links to screencasts, updated documentation with new changes and fixed other typos and composition errors.

* Remove fisher update --cache in favor of fisher --list | fisher update and fisher uninstall --all in favor of fisher --list | fisher uninstall.

* Fisherman does not move initialization / configuration files following the convention name.config.fish to $fisher_config/functions, but to $fisher_config/conf.d now and evaluates each *.config.fish* inside at shell start as usual. #13.

* ~~Add fisher --cache[=base] option to retrieve contents in $fisher_cache, eliminating flaky usage of find(1)~~. #11.

* Fisherman now generates information about plugins installed via custom URLs. For the description, a shortened version of the URL is used. For the URL the full URL is used. For tags, the URL is fuzzily checked and tags such as theme, plugin, config and omf are added. The tag ~~_orphan_~~ **custom** is added by default as well. Finally, the author is generated by retrieving the e-mail or username of the author of the first commit in the plugin's repository. #9 and #14.

* ~~Change --path-in-cache to --translate. This function translates an name or supported URL/URL variation into a path inside $fisher_cache. This allows you to treat plugins installed via custom URLs almost like regular plugins if they are installed. #8.~~

* Fix a bug where mktemp would fail in some systems. #7. Thanks @tobywf.

* Add [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md). #6.

* Fisherman can now unload themes within the same shell, without having to restart the session. #5.

* Fisherman can now load themes within the same shell, without having to restart the session using exec fish. Shoddy themes, for example those failing to declare global variables with the -g flag still require the session to be reset. See [**related**](https://github.com/oh-my-fish/theme-bobthefish/pull/19). #4.

* ~~Move getopts implementation to share/getopts.awk.~~ #3.

* Support dots inside URIs in fisher --validate. #2.

* Refactor and improve tests for install, update and uninstall.

## [0.1.0][v010] - 2016-01-01

* Initial commit.

<!--  Links -->

[v100]: https://github.com/fisherman/fisherman/releases/tag/1.0.0
[v090]: https://github.com/fisherman/fisherman/releases/tag/0.9.0
[v080]: https://github.com/fisherman/fisherman/releases/tag/0.8.0
[v070]: https://github.com/fisherman/fisherman/releases/tag/0.7.0
[v060]: https://github.com/fisherman/fisherman/releases/tag/0.6.0
[v050]: https://github.com/fisherman/fisherman/releases/tag/0.5.0
[v040]: https://github.com/fisherman/fisherman/releases/tag/0.4.0
[v031]: https://github.com/fisherman/fisherman/releases/tag/0.3.1
[v030]: https://github.com/fisherman/fisherman/releases/tag/0.3.0
[v020]: https://github.com/fisherman/fisherman/releases/tag/0.2.0
[v010]: https://github.com/fisherman/fisherman/releases/tag/0.1.0
