set -l key_bindings_mock "##foo##" "foo" "bar" "baz" "##foo##"

test "$TESTNAME - Delete bindings for plugin from input stream"
    -z (printf "%s\n" $key_bindings_mock | __fisher_key_bindings_delete foo)
end

test "$TESTNAME - Write new stream with deleted bindings to stdout"
     $key_bindings_mock = (
         printf "%s\n" $key_bindings_mock | __fisher_key_bindings_delete norf)
end
