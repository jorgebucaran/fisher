function __fisher_name -d "get plugin name from url or path"
    sed -E 's|.*/(.*)|\1|; s/^(plugin|theme|pkg|omf|fish|fisher)-//'
end
