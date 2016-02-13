function spin -a commands
    fish -c "$commands" ^ /dev/stderr
end
