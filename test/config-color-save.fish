set -l path $DIRNAME/.t-$TESTNAME-(random)

function -S setup
    mkdir -p $path/{foo,bar}

    __fisher_config_color_save $path/foo/fish_colors

    touch $path/bar/fish_colors
end

function -S teardown
    rm -rf $path
end

test "$TESTNAME - Create fish_colors in path"
    -s $path/foo/fish_colors
end

test "$TESTNAME - Create fish_colors in path"
    1 = (
        __fisher_config_color_save $path/bar/fish_colors
        echo $status
        )
end
