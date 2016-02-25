function __fisher_name
    sed -E '
        s|.*/(.*)|\1|
        s/(plugin|omf-theme|theme|pkg|omf|fish|fisher|fisherman)-//g
    '
end
