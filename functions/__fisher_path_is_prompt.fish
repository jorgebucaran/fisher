function __fisher_path_is_prompt -a path
    test \
        -e $path/fish_prompt.fish -o -e $path/fish_right_prompt.fish -o \
        -e $path/functions/fish_prompt.fish -o -e $path/functions/fish_right_prompt.fish
end
