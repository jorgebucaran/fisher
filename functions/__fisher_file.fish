function __fisher_file -d "read one or more fishfiles"
    awk  '
        !/^ *(#.*)*$/ {
            gsub("#.*", "")

            if (/^ *package .+/) {
                $1 = $2
            }

            if (!duplicates[$1]++) {
                printf("%s\n", $1)
            }
        }
    ' $argv
end
