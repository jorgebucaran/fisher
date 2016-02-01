function __fisher_file
    awk  '
        /^[ \t]*(package|theme) .+/ {
            if ($1 == "package") {
                $1 = "https://github.com/oh-my-fish/plugin-"$2
            } else {
                $1 = "https://github.com/oh-my-fish/theme-"$2
            }
        }

        !/^[ \t]*(#.*)*$/ {
            gsub("#.*", "")

            if (! seen[$1]++) {
                printf("%s\n", $1)
            }
        }
    '
end
