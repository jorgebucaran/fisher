# We need to iterate over each page because piping to | xargs man will use
# the system `man` instead of our fish-only wrapper.

for page in (fisher help --commands=bare | awk '{ print "fisher-"$1 }')
    test "$TESTNAME - Wrap man and add fisherman to MANPATH to display fisher docs"
        "$page(1)" = (man $page | awk '{ print tolower($1); exit }')
    end
end
