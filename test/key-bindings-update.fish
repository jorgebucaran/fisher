# We use key-bindings-update to extract a plugin's declared key bindings and
# append them to $fisher_binds.

set -l path $DIRNAME/fixtures/key-bindings/update

test "$TESTNAME - Add plugin key bindings to fish_user_key_bindings function"
    (__fisher_key_bindings_update < $path/fish_user_key_bindings_function.fish \
        | xargs) = "#### foo bar baz ####"
end

test "$TESTNAME - Add plugin key bindings inside a key_bindings function"
    (__fisher_key_bindings_update < $path/key_bindings_function.fish \
        | xargs) = "#### foo bar baz ####"
end

test "$TESTNAME - Add plugin key bindings written in a file"
    (__fisher_key_bindings_update < $path/key_bindings_file.fish \
        | xargs) = "#### foo bar baz ####"
end
