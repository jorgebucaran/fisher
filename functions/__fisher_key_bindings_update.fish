function __fisher_key_bindings_update -a name
    fish_indent | awk \
        -v name="$name" \
        -v pattern="^function (fish_user_)?key_bindings\$" '

        function banner() {
            print "##" name "##"
        }

        BEGIN { banner() } END { banner() }

        $0 ~ pattern {
            end = 1
            next
        }

        /^end$/ && end {
            end = 0
            next
        }

        !/^ *(#.*)*$/ {
            gsub("#.*", "")

            printf("%s\n", $0)
        }
    '
end
