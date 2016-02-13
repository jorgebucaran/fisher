function __fisher_path_update -a path
    git -C $path checkout master --quiet ^ /dev/null
    git -C $path pull --rebase origin master --quiet 
end
