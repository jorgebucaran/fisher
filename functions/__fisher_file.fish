function __fisher_file
    awk -v FS=\t '
        /@http/ {
            gsub("@.*$", "", $1)
        }

        !/^[ \t]*(#.*)*$/ {
            gsub("^[@*>]|#.*", "")

            if (! seen[$1]++) {
                printf("%s\n", $1)
            }
        }
    '
end
