function __fisher_name -d "Generate a pretty name from a plugin path or URL"
    sed -E 's|.*/(.*)|\1|; s/^(plugin|theme|pkg|omf|fish|fisher)-//'
end
