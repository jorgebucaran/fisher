set -l path $DIRNAME/$TESTNAME.test(random)
set -l index $path/index
set -l names foo bar baz #norf
set -l cache foo bar

set -l url https://hoge.com
set -l info info

function -S search_make_record
    awk -v url=$url -v info=$info -v author=Mr. '
        {
            printf("%s\n%s\n%s\n%s\nMr.%s\n\n", $0, url"/"$0, info, "t a g s", $0)
        }
    '
end

function -S setup
    if not mkdir -p $path
        return 1
    end

    set -g fisher_cache $path/cache
    set -g fisher_index "file://$index"

    printf "%s\n" $names | search_make_record > $index

    for i in $cache
        mkdir -p $fisher_cache/$i
    end
end

function -S teardown
    rm -rf $path
end

test "use \$fisher_cache for local cache and \$fisher_index for data source"
    (fisher search --name --select=all) = $names
end

test "--select=cache shows names packages also in the cache"
    (fisher search --select=cache | xargs) = (printf "%s\n" $cache | search_make_record | xargs)
end

test "--select=remote shows names packages sans local cache"
    (fisher search --select=remote) = (

    for i in $names
        if not contains -- $i $cache
            printf "%s\n" $i | search_make_record
        end
    end)
end

test "--field=name filters data by name field"
  (fisher search --field=name) = $names
end

test "--field=url filters data by url field"
    (fisher search --field=url) = (

    for i in $names
        printf "%s\n" $url/$i
    end)
end

test "--field=info filters data by info field"
    (fisher search --field=info) = (

    printf "$info\n%.0s" (seq (count $names)))
end

test "--field=author filters data by author field"
    (fisher search --field=author) = (printf "Mr.%s\n" $names)
end

for field in name url info author
    test "--$field is a shorthand for --field=$field"
        (fisher search --$field) = (fisher search --field=$field)
    end
end

test "--name=<name> finds given record"
    (fisher search --name=foo) = (echo foo | search_make_record)
end

test "--author=<author> finds given record"
    (fisher search --author=Mr.foo) = (printf "%s\n" foo | search_make_record)
end

test "search <name> finds given record by name"
    (fisher search bar) = (printf "%s\n" bar | search_make_record)
end

test "search <u/r/l> finds given record by url"
    (fisher search $url/bar) = (printf "%s\n" bar | search_make_record)
end

test "search non-matches with --<field>!=<value>"
  (fisher search --name!=foo --field=name) = (
    printf "%s\n" $names | while read -l name
      if not test $name = foo
        echo $name
      end
    end)
end

test "search for regex matches with --<field>~/regex/"
    (fisher search --name~/..../ --field=name) = (

    printf "%s\n" $names | awk 'length($0) == 4  { print }')
end

test "search for regex non-matches with --<field>!~/regex/"
    (fisher search --name!~/..../ --field=name) = (

    printf "%s\n" $names | awk 'length($0) != 4  { print }')
end

test "use --and operator to join a query w/ the default search query"
    (fisher search bar --or --name=baz) = (printf "%s\n" bar baz | search_make_record)
end

test "use --or operator to join two queries"
    (fisher search --name=baz --or --name=foo --field=name) = (echo baz\nfoo)
end

test "use --query=<query> to specify any search query"
    (fisher search --query="name!~/^[fb]/") = (

    printf "%s\n" $names | awk '$0!~/^[fb]/ { print }' | search_make_record)
end

test "use --query=<query> to specify any search query and filter with --field"
    (fisher search --query="name~/^[fb]/" --field=name) = (

    printf "%s\n" $names | awk '$0~/^[fb]/ { print }')
end

test "use --quiet to enable quiet mode"
    (fisher search --quiet --name=%%%; echo $status) = 1
end
