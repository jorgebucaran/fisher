echo pyon pyon

function ponyo_install --on-event ponyo_install
    set --global ponyo pyon pyon
end

function ponyo_update --on-event ponyo_update
    set --global --append ponyo pyon
end

function ponyo_uninstall --on-event ponyo_uninstall
    set --erase ponyo
end