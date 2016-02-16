function __fisher_help_commands
    for i in (functions -a | grep -E '^fisher_[^_]+$')
        functions $i | awk '

          /^$/ { next } {
              printf("%s;", substr($2, 8))

              gsub("\'", "")

              for (i = 4; i <= NF && $i !~ /^--.*/; i++) {
                  printf("%s ", $i)
              }

              print ""
              exit
          }

        '
    end
end
