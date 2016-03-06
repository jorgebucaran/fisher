function __fisher_config_color_save
    if test ! -f "$fisher_config/fish_colors"
        printf "%s\n"                       \
            "$fish_color_normal"            \
            "$fish_color_command"           \
            "$fish_color_param"             \
            "$fish_color_redirection"       \
            "$fish_color_comment"           \
            "$fish_color_error"             \
            "$fish_color_escape"            \
            "$fish_color_operator"          \
            "$fish_color_quote"             \
            "$fish_color_autosuggestion"    \
            "$fish_color_valid_path"        \
            "$fish_color_cwd"               \
            "$fish_color_cwd_root"          \
            "$fish_color_match"             \
            "$fish_color_search_match"      \
            "$fish_color_selection"         \
            "$fish_pager_color_prefix"      \
            "$fish_pager_color_completion"  \
            "$fish_pager_color_description" \
            "$fish_pager_color_progress"    \
            "$fish_color_history_current" > "$fisher_config/fish_colors"
    end
end
