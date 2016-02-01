set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/completions
    echo "echo ok" > $path/completions/fisher.fish

    set -g fisher_home $path

    function complete
        echo $argv
    end
end

function -S teardown
    rm -rf $path
    functions -e complete
end

test "$TESTNAME - Remove Fisherman completions"
    (__fisher_complete_reset | sed -n 1p) = "-ec fisher"
end

test "$TESTNAME - Evaluate completions/fisher.fish"
    (__fisher_complete_reset | sed -n 2p) = "ok"
end
