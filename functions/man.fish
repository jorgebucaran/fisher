function man -d "Format and display the on-line manual pages"
    set -lx MANPATH {$__fish_datadir,$fisher_config,$fisher_home}/man $MANPATH ""
    command man $argv
end
