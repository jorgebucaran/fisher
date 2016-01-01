set -l id foo bar
set -l host baz
set -l tld org

function -S setup
    set -g fisher_default_host https://$host.$tld
end

test "validate names"
    $id[1] = (fisher --validate=$id[1])
end

test "validate uris"
    $fisher_default_host/$id[1]/$id[2] = (fisher --validate=$id[1]/$id[2])
end

test "validate names may end with a number"
    "a0" = (fisher --validate=a0)
end

test "validate names may start in uppercase"
    -z (fisher --validate=A)
end

test "validate names may not start with a number"
    -z (fisher --validate=0abc)
end

test "supress validation output"
    -z (fisher -q --validate=$id[1])
end

test "remove `/' from uris"
    $fisher_default_host/$id[1]/$id[2] = (fisher --validate=$id[1]/$id[2]/)
end

test "remove `.git' from uris"
    $fisher_default_host/$id[1]/$id[2] = (fisher --validate=$id[1]/$id[2].git)
end

test "file:/// uris"
    ! -z (fisher --validate=file:///$id[1]/$id[2].git)
end

test "id/id uris"
    ! -z (fisher --validate=$id[1]/$id[2].git)
end

test "short owner/repo uris"
    https://github.com/$id[1]/$id[2] = (fisher --validate=github/$id[1]/$id[2])
end

test "short $short:owner/repo uris"
    https://github.com/$id[1]/$id[2] = (fisher --validate=gh:$id[1]/$id[2])
end

test "short bitbucket urls uris"
    https://bitbucket.org/$id[1]/$id[2] = (fisher --validate=bb:$id[1]/$id[2])
end

test "short gitlab urls uris"
    https://gitlab.com/$id[1]/$id[2] = (fisher --validate=gl:$id[1]/$id[2])
end
