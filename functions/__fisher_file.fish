function __fisher_file
    awk -v FS=\t '
        /^[ \t]*package / {
            gsub("^[ \t]*package ", "https://github.com/oh-my-fish/plugin-")
            printf("%s\n", $0)
            next
        }
        
        /@http/ {
            gsub("@.*$", "", $1)
        }

        !/^[ \t]*(#.*)*$/ {
            gsub("^[@*>]?[ \t]*?|#.*", "")

            if (! seen[$1]++) {
                printf("%s\n", $1)
            }
        }
    '
end
