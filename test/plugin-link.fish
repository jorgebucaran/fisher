function -S setup
    function __fisher_plugin_link
        echo "$argv"
    end
end

function -S teardown
    functions -e __fisher_plugin_link
end

test "$TESTNAME - Link source to target with options (hard / soft)"
    "options source target" = (__fisher_plugin_link options source target)
end
