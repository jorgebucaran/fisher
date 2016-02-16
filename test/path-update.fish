set -g path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/foo

    function git
        if test (pwd) = $path/foo
            switch "$argv"
                case "checkout master --quiet"
                    printf checkout-

                case "pull --rebase origin master --quiet"
                    printf pull-rebase
            end
        end
    end
end

function -S teardown
    functions -e git
    rm -rf $path
end

test "$TESTNAME - Use Git to update given path"
    "checkout-pull-rebase" = (__fisher_path_update $path/foo)
end
