function fisher_mock_repos
    for name in $argv
        git -C $name init --quiet
        git -C $name config user.email "git@fisherman"
        git -C $name config user.name "fisherman"
        git -C $name add -A > /dev/null
        git -C $name commit -m "$name" > /dev/null
    end
end
