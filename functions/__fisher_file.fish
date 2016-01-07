function __fisher_file -a file -d "Read a fishfile and display its contents"
    switch "$file"
        case ""
            set file $fisher_config/fishfile
            
        case "-"
            set file /dev/stdin
    end

    awk  '
        !/^ *(#.*)*$/ {
            gsub("#.*", "")

            if (/^ *package .+/) $1 = $2

            if (!duplicates[$1]++) printf("%s\n", $1)
        }
    ' $file
end
