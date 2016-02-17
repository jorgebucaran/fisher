##
#  The following table lists Fisherman, Tacklebox, OMF and Wahoo plugin system rules.
#
#    foobar/
#    ├── foobar.fish                       Function/Init File      *
#    ├── foobar.load                       Init File               OMF Tacklebox
#    ├── before.init.fish                  Pre-Init File           OMF
#    ├── uninstall.fish                    Destroy Files           OMF Wahoo
#    ├── completions                       Completions             *
#    │   └── foobar.fish
#    ├── init.fish                         Init File               OMF Wahoo
#    ├── config.fish                       Init File               Fisherman
#    ├── conf.d                            Init Files              Fisherman
#    │   └── conf.fish
#    ├── modules                           Init Files              Tacklebox
#    │   └── mod.fish
#    ├── fish_title.fish                   Window Title
#    ├── fish_greeting.fish                Intro Message
#    ├── fish_prompt.fish                  Theme/Prompt File       *
#    ├── fish_right_prompt.fish            Theme/Prompt File       *
#    ├── fish_user_key_bindings.fish       Bindings File           Fisherman
#    ├── quux.awk                          Script File             Fisherman OMF
#    ├── functions                         Shared Functions        *
#    │   ├── foobar-baz.fish
#    │   ├── foobar.awk
#    │   ├── foobar.php
#    │   ├── foobar.pl
#    │   ├── foobar.py
#    │   ├── foobar.rb
#    │   ├── foobar.sed
#    │   └── lib                           Nested Functions        OMF
#    │       └── __foobar.fish
#    └── man                               Manual Pages            Fisherman
#        ├── man1
#        │   └── foobar.1
#        ├── man2
#        │   └── foobar.2
#        ├── man3
#        │   └── foobar.3
#        ├── man4
#        │   └── foobar.4
#        ├── man5
#        │   └── foobar.5
#        ├── man6
#        │   └── foobar.6
#        ├── man7
#        │   └── foobar.7
#        ├── man8
#        │   └── foobar.8
#        └── man9
#            └── foobar.9
#
#    When we install Foobar, plugin-walk is used to generate a class | source | target | name
#    table that indicates the caller which files are functions, bindings, etc.
#
#    Class
#      --              Regular autoloaded functions.
#
#      --source        Initialization or theme/prompt files. We also source foobar.fish because we
#                      want its function to be immediately available at the command line.
#
#      --bind          Key bindings.
#      --man           Manual pages.
#      --uninstall     Oh My Fish! uninstall event file.
#
#    Source
#      The source of the file that needs to be copied.
#
#    Target
#      The base of the target the file will be copied to.
#
#    Name
#      The name of a regular autoloaded function. We use this parameter in __fisher_plugin_disable
#      to erase the function so that it is immediately unavailable.
#
#    Class         Source           Target                               Name
#    ===========================================================================================
#    --source      foobar/....      conf.d/foobar.before.init.fish
#    --source      foobar/...       conf.d/foobar.config.fish
#    --source      foobar/...       functions/fish_greeting.fish         fish_greeting
#    --source      foobar/...       functions/fish_prompt.fish           fish_prompt
#    --source      foobar/...       functions/fish_right_prompt.fish     fish_right_prompt
#    --source      foobar/...       functions/fish_title.fish            fish_title
#    --bind        foobar/...
#    --source      foobar/...       functions/foobar.fish foobar         foobar
#    --source      foobar/...       conf.d/foobar.init.fish
#    --uninstall   foobar/...
#    --source      foobar/...       conf.d/foobar.conf.fish
#    --source      foobar/...       conf.d/foobar.mod.fish
#    --source      foobar/...       functions/foobar-baz.fish            foobar-baz
#    --source      foobar/...       functions/__foobar.fish              __foobar
#    --source      foobar/...       conf.d/foobar.load.fish
#    --source      foobar/...       completions/foobar.fish
#    --            foobar/...       functions/foobar.py
#    --            foobar/...       functions/foobar.rb
#    --            foobar/...       functions/foobar.php
#    --            foobar/...       functions/foobar.pl
#    --            foobar/...       functions/foobar.awk
#    --            foobar/...       functions/foobar.sed
#    --            foobar/...       functions/quux.awk
#    --man         foobar/...       man/man1/foobar.1
#    --man         foobar/...       man/man2/foobar.2
#    --man         foobar/...       man/man3/foobar.3
#    --man         foobar/...       man/man4/foobar.4
#    --man         foobar/...       man/man5/foobar.5
#    --man         foobar/...       man/man6/foobar.6
#    --man         foobar/...       man/man7/foobar.7
#    --man         foobar/...       man/man8/foobar.8
#    --man         foobar/...       man/man9/foobar.9
##

set -l foobar $DIRNAME/fixtures/plugins/foobar
set -l path $DIRNAME/fixtures/path-walk

test "$TESTNAME - Generate class | source | target | name table" (
    __fisher_plugin_walk foobar $foobar | awk '{print $1,$3,$4}') = (
        awk '{print $1,$2,$3}' $path/foobar-path-walk
        )
end

test "$TESTNAME - Walk a plugin's path writing relevant target / source names to stdout" (
    __fisher_plugin_walk foobar $foobar | awk '{print $2}' | sed 's|.*/||') = (
        cat $path/foobar-source-files
        )
end

# See also plugin-walk-* individual tests for an exhaustive explanation of each item.
