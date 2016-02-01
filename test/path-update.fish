function -S setup
    function git
        switch "$argv"
            case "-C foo/bar checkout master --quiet"
                printf checkout-
            case "-C foo/bar pull --rebase origin master --quiet"
                printf pull-rebase
        end
    end
end

function -S teardown
    functions -e git
end

test "$TESTNAME - Use Git to update given path"
    "checkout-pull-rebase" = (__fisher_path_update foo/bar)
end
