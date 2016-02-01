function getopts -d "Parse CLI options"
    if not set -q argv[1]
        return 1
    end

    printf "%s\n" $argv | sed -E '
        s/^-([A-Za-z]+)/- \1 /; s/^--([A-Za-z0-9_-]+)(!?)=?(.*)/-- \1 \3 \2 /' | awk '

        function out(k,v) { if (!seen[k v]++) print k (v == "" ? "" : " "v) }
        function pop()    { return len <= 0 ? "_" : opt[len--] }

        !/^ *$/ {
            if (done) out("_" , $1$2$3)
            else if ($1 == "--" && !$2) done = 1
            else if ($2 == "" || $1 !~ /^-|^--/ ) out(pop(), $0)
            else {
                while (len) out(pop())
                if ($3) for (i = 4; i <= NF; i++) $3 = $3" "$i
                if ($1 == "--") if ($3 == "") opt[++len] = $2; else out($2, $3)
                if ($1 == "-") {
                  if ($2 == "") { print $1; next } else n = split($2, keys, "")
                  if ($3 == "") opt[++len] = keys[n]; else out(keys[n], $3)
                  for (i = 1; i < n; i++) out(keys[i])
                }
            }
        }
        END { while (len) out(pop()) }
    '
end
