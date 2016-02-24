function __fisher_url_clone -a url path
    env GIT_ASKPASS=/bin/echo git clone -q --depth 1 $url $path
end
