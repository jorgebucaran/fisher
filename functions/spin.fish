function spin -a commands
    fish -c "$commands" ^ /dev/null
end
