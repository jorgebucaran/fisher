function __fisher_file_contains -a plugin
    set -e argv[1]
    grep -E "^(package *|plugin *)?$plugin.*\$" $argv
end
