set --local fisher_subcommands install update remove list
complete --command fisher --exclusive --long help --description "Print help"
complete --command fisher --exclusive --long version --description "Print version"
complete --command fisher --exclusive --condition "not __fish_seen_subcommand_from $fisher_subcommands" --arguments install --description "Install plugins"
complete --command fisher --exclusive --condition "not __fish_seen_subcommand_from $fisher_subcommands" --arguments update --description "Update installed plugins"
complete --command fisher --exclusive --condition "not __fish_seen_subcommand_from $fisher_subcommands" --arguments remove --description "Remove installed plugins"
complete --command fisher --exclusive --condition "not __fish_seen_subcommand_from $fisher_subcommands" --arguments list --description "List installed plugins matching regex"
complete --command fisher --exclusive --condition "__fish_seen_subcommand_from update remove" --arguments "(fisher list)"
