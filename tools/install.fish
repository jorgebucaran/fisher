pushd
    git clone https://github.com/fisherman/fisherman ~/.fisherman --depth=1
    cd ~/.fisherman
    make
popd
exec fish < /dev/tty
