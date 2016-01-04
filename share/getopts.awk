function add(k, v) {
    if (seen[k v]++) return
    print k (v == "" ? "" : " "v)
}

function pop() {
    return (size <= 0) ? "_" : stack[size--]
}

function push(k) {
    stack[++size] = k
}

function flush() {
    while (size) {
        add(pop())
    }
}

$0 == "" { next }

done {
    add("_" , $1$2$3)
    next
}

$1 == "--" && !$2 {
    done = 1
    next
}

$1 !~ /^-|^--/ {
    add(pop(), $0)
    next
}

size { flush() }

$3 {
    for (i = 4; i <= NF; i++)
        $3 = $3" "$i
}

$1 == "--" {
    if ($3 == "")
        push($2)
    else
        add($2, $3)
}

$1 == "-" {
    if ($2 == "") {
        print $1
        next
    } else {
        n = split($2, keys, "")
    }

    if ($3 == "")
        push(keys[n])
    else
        add(keys[n], $3)

    for (i = 1; i < n; i++)
        add(keys[i])
}

END { flush() }
