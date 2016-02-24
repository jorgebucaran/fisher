function __fisher_url_clone -a url path
    set -lx GIT_ASKPASS /bin/echo 
    git clone -q --depth 1 $url $path
end
