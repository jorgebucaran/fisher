function __fisher_config_color_reset
    if test ! -f "$fisher_config/fish_colors"
        set -U fish_color_normal normal
        set -U fish_color_command 005fd7 purple
        set -U fish_color_param 00afff cyan
        set -U fish_color_redirection normal
        set -U fish_color_comment red
        set -U fish_color_error red --bold
        set -U fish_color_escape cyan
        set -U fish_color_operator cyan
        set -U fish_color_quote brown
        set -U fish_color_autosuggestion 555 yellow
        set -U fish_color_valid_path --underline
        set -U fish_color_cwd green
        set -U fish_color_cwd_root red
        set -U fish_color_match cyan
        set -U fish_color_search_match --background=purple
        set -U fish_color_selection --background=purple
        set -U fish_pager_color_prefix cyan
        set -U fish_pager_color_completion normal
        set -U fish_pager_color_description 555 yellow
        set -U fish_pager_color_progress cyan
        set -U fish_color_history_current cyan

        return
    end

    read -laz fish_colors < $fisher_config/fish_colors

    set -U fish_color_normal            $fish_colors[1]
    set -U fish_color_command           $fish_colors[2]
    set -U fish_color_param             $fish_colors[3]
    set -U fish_color_redirection       $fish_colors[4]
    set -U fish_color_comment           $fish_colors[5]
    set -U fish_color_error             $fish_colors[6]
    set -U fish_color_escape            $fish_colors[7]
    set -U fish_color_operator          $fish_colors[8]
    set -U fish_color_quote             $fish_colors[9]
    set -U fish_color_autosuggestion    $fish_colors[10]
    set -U fish_color_valid_path        $fish_colors[11]
    set -U fish_color_cwd               $fish_colors[12]
    set -U fish_color_cwd_root          $fish_colors[13]
    set -U fish_color_match             $fish_colors[14]
    set -U fish_color_search_match      $fish_colors[15]
    set -U fish_color_selection         $fish_colors[16]
    set -U fish_pager_color_prefix      $fish_colors[17]
    set -U fish_pager_color_completion  $fish_colors[18]
    set -U fish_pager_color_description $fish_colors[19]
    set -U fish_pager_color_progress    $fish_colors[20]
    set -U fish_color_history_current   $fish_colors[21]

    rm -f $fisher_config/fish_colors
end
