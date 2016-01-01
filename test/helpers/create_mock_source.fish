function create_mock_source -a path
    set -e argv[1]

    for name in $argv
        if not mkdir -p $path/$name/{,functions,completions,man}
            return 1
        end

        echo "function $name; end;" >> $path/$name/$name.fish
        echo > $path/$name/functions/$name.func.fish
        echo > $path/$name/completions/$name.fish

        for n in (seq 9)
            mkdir -p $path/$name/man/man$n
            echo $name >> $path/$name/man/man$n/$name.$n
        end

        git -C $path/$name init --quiet

        git -C $path/$name config user.email "man@fisher"
        git -C $path/$name config user.name "fisherman"

        git -C $path/$name add -A > /dev/null
        git -C $path/$name commit -m "add $name.fish" > /dev/null

        printf "$name\nfile://$path/$name\n$name's plugin\nt a g s\n@$name\n\n"
    end
end
