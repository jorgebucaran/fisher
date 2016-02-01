# We use key-bindings-update-user to modify the global fish_user_key_bindings.fish
# file to add the call to __fisher_key_bindings always at the top of the function
# or add it, if it isn't there already.

set -l path $DIRNAME/fixtures/key-bindings/update

test "$TESTNAME - Add __fisher_key_bindings if not present"
    (__fisher_key_bindings_update_user < $path/fish_user_key_bindings_empty.fish \
        | xargs) = "function fish_user_key_bindings __fisher_key_bindings end"
end

test "$TESTNAME - Move __fisher_key_bindings to top of function"
    (__fisher_key_bindings_update_user < $path/fish_user_key_bindings_bottom.fish \
        | xargs) = "function fish_user_key_bindings __fisher_key_bindings # 1 # 2 end"
end
