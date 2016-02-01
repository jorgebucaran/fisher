set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/{good,empty,none}

    echo . > $path/good/Makefile
    touch $path/empty/Makefile

    function make
        if test ! -z "$argv"

        # When we install a plugin that includes a Makefile we must make sure to run
        # only its default targets, not `make install`.

        # A plugin may support multiple install methods and the install target would
        # bypass Fisherman. A good example is Fishtape itself.

            return 1
        end

        # We also want to check whether we are inside the root of the project when
        # running `make` in order to improve our chances of success.

        pwd
    end
end

function -S teardown
    rm -rf $path
    functions -e make
end

test "$TESTNAME - Do not run any make targets"
    (__fisher_path_make $path/good > /dev/null; printf $status) -ne 1
end

test "$TESTNAME - Run make at the root of the plugin directory"
    (__fisher_path_make $path/good) = "$path/good"
end

set -l last_pwd

test "$TESTNAME - Pop path after make exits"
    (set last_pwd (pwd); __fisher_path_make $path/good > /dev/null; pwd) = "$last_pwd"
end

test "$TESTNAME - Succeed even if makefile is empty"
    (__fisher_path_make $path/empty; printf $status) -eq 0
end

test "$TESTNAME - Succeed even if there is no makefile"
    (__fisher_path_make $path/none; printf $status) -eq 0
end
