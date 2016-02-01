function __fisher_url_clone -a url path
    git clone -q --depth 1 $url $path
end
