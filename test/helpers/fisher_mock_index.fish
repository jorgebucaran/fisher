function fisher_mock_index
    for name in $argv[2..-1]
        printf "$name\nfile://$argv[1]/$name\ninfo\ntag1 tag2\n@$name\n\n"
    end
end
