set -l key_bindings_mock "##foo##" "bind foo" "bind bar" "##foo##"

test "$TESTNAME - Undo bind calls with bind --erase #1"
    (printf "%s\n" $key_bindings_mock \
        | __fisher_key_bindings_undo foo | sed -n 1p) = "bind -e foo"
end

test "$TESTNAME - Undo bind calls with bind --erase #2"
    (printf "%s\n" $key_bindings_mock \
        | __fisher_key_bindings_undo foo | sed -n 2p) = "bind -e bar"
end
