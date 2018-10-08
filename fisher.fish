set -g fisher_version 3.0.8

type source >/dev/null; or function source; . $argv; end

switch (command uname)
    case Darwin FreeBSD
        function _fisher_now -a elapsed
            command perl -MTime::HiRes -e 'printf("%.0f\n", (Time::HiRes::time() * 1000) - $ARGV[0])' $elapsed
        end
    case \*
        function _fisher_now -a elapsed
            command date "+%s%3N" | command awk "{ sub(/3N\$/,\"000\"); print \$0 - 0$elapsed }"
        end
end

function fisher -a cmd -d "fish package manager"
    if not command which curl >/dev/null
        echo "curl is required to use fisher -- install curl and try again" >&2
        return 1
    end

    test -z "$XDG_CACHE_HOME"; and set XDG_CACHE_HOME ~/.cache
    test -z "$XDG_CONFIG_HOME"; and set XDG_CONFIG_HOME ~/.config

    set -g fish_config $XDG_CONFIG_HOME/fish
    set -g fisher_cache $XDG_CACHE_HOME/fisher
    set -g fisher_config $XDG_CONFIG_HOME/fisher

    test -z "$fisher_path"; and set -g fisher_path $fish_config

    command mkdir -p {$fish_config,$fisher_path}/{functions,completions,conf.d} $fisher_cache

    if test ! -e "$fisher_path/completions/fisher.fish"
        echo "fisher self-complete" > $fisher_path/completions/fisher.fish
        _fisher_self_complete
    end

    switch "$cmd"
        case self-complete
            _fisher_self_complete
        case ls
            _fisher_ls | command sed "s|$HOME|~|"
        case -v {,--}version
            _fisher_version (status -f)
        case -h {,--}help
            _fisher_help
        case self-update
            _fisher_self_update (status -f); or return
            _fisher_self_complete
        case self-uninstall
            _fisher_self_uninstall
        case add rm ""
            if test ! -z "$argv"
                if not isatty
                    while read -l i
                        set argv $argv $i
                    end
                end
            end
            _fisher_commit $argv; or return
            _fisher_self_complete
        case \*
            echo "error: unknown flag or command \"$cmd\"" >&2
            _fisher_help >&2
            return 1
    end
end

function _fisher_self_complete
    complete -c fisher --erase
    complete -xc fisher -n __fish_use_subcommand -a version -d "Show version"
    complete -xc fisher -n __fish_use_subcommand -a help -d "Show help"
    complete -xc fisher -n __fish_use_subcommand -a self-update -d "Update fisher"
    complete -xc fisher -n __fish_use_subcommand -a ls -d "List installed packages"
    complete -xc fisher -n __fish_use_subcommand -a rm -d "Remove packages"
    complete -xc fisher -n __fish_use_subcommand -a add -d "Add packages"
    for pkg in (_fisher_ls)
        complete -xc fisher -n "__fish_seen_subcommand_from rm" -a $pkg
    end
end

function _fisher_ls
    set -l pkgs $fisher_config/*/*/*
    for pkg in $pkgs
        command readlink $pkg; and continue; or echo $pkg
    end | command sed "s|$fisher_config/*||;s|github\.com/||"
end

function _fisher_version -a file
    echo "fisher version $fisher_version $file" | command sed "s|$HOME|~|"
end

function _fisher_help
    echo "usage: fisher add <PACKAGES>    add packages"
    echo "       fisher rm  <PACKAGES>    remove packages"
    echo "       fisher ls                list installed packages"
    echo "       fisher self-update       update fisher"
    echo "       fisher self-uninstall    uninstall fisher & all packages"
    echo "       fisher help              show this help"
    echo "       fisher version           show version"
    echo
    echo "examples:"
    echo "       fisher add jethrokuan/z rafaelrinaldi/pure"
    echo "       fisher add gitlab.com/owner/foobar@v2"
    echo "       fisher add ~/myfish/mypkg"
    echo "       fisher rm rafaelrinaldi/pure"
    echo "       fisher ls | fisher rm"
end

function _fisher_self_update -a file
    set -l url "https://raw.githubusercontent.com/jorgebucaran/fisher/master/fisher.fish"
    echo "fetching $url" >&2

    curl -s "$url?nocache" >$file@

    set -l next_version (awk 'NR == 1 { print $4; exit }' < $file@)
    switch "$next_version"
        case "" $fisher_version
            command rm -f $file@
            if test -z "$next_version"
                echo "cannot update fisher -- are you offline?" >&2
                return 1
            end
            echo "fisher is already up-to-date" >&2
        case \*
            echo "linking $file" | command sed "s|$HOME|~|" >&2
            command mv -f $file@ $file
            source $file
            echo "updated fisher to $fisher_version -- hooray!" >&2
    end
end

function _fisher_self_uninstall
    set -l current_pkgs $fisher_config/*/*/*
    for path in $fisher_cache (_fisher_pkg_remove_all $current_pkgs) $fisher_config $fisher_path/{functions,completions}/fisher.fish $fish_config/fishfile
        echo "removing $path"
        command rm -rf $path 2>/dev/null
    end | command sed "s|$HOME|~|" >&2

    set -e fisher_cache
    set -e fisher_config
    set -e fisher_path
    set -e fisher_version

    complete -c fisher --erase
    functions -e (functions -a | command awk '/^_fisher/') fisher

    echo "done -- see you again!" >&2
end

function _fisher_commit
    set -l elapsed (_fisher_now)
    set -l current_pkgs $fisher_config/*/*/*
    set -l removed_pkgs (_fisher_pkg_remove_all $current_pkgs)
    command rm -rf $fisher_config
    command mkdir -p $fisher_config

    set -l fishfile $fish_config/fishfile
    if test ! -e "$fishfile"
        command touch $fishfile
        echo "created empty fishfile in $fishfile" | command sed "s|$HOME|~|" >&2
    end
    printf "%s\n" (_fisher_fishfile_indent (echo -s $argv\;) < $fishfile) > $fishfile

    set -l expected_pkgs (_fisher_fishfile_load < $fishfile)
    set -l added_pkgs (_fisher_pkg_fetch_all $expected_pkgs)
    set -l updated_pkgs (
        for pkg in $removed_pkgs
            set pkg (echo $pkg | command sed "s|$fisher_config/*||")
            if contains -- $pkg $added_pkgs
                echo $pkg
            end
        end)

    if test -z "$added_pkgs$updated_pkgs$removed_pkgs$expected_pkgs"
        echo "nothing to commit -- try adding some packages" >&2
        return 1
    end

    echo (count $added_pkgs) (count $updated_pkgs) (count $removed_pkgs) (_fisher_now $elapsed) | _fisher_status_report >&2
end

function _fisher_pkg_remove_all
    for pkg in $argv
        echo $pkg
        _fisher_pkg_uninstall $pkg
    end
end

function _fisher_pkg_fetch_all
    set -l pkg_jobs
    set -l local_pkgs
    set -l actual_pkgs
    set -l expected_pkgs

    for name in $argv
        switch $name
            case \~\* /\*
                set -l path (echo "$name" | command sed "s|~|$HOME|")
                if test -e "$path"
                    set local_pkgs $local_pkgs $path
                else
                    echo "cannot install \"$name\" -- is this a valid file?" >&2
                end
                continue
            case https://\* ssh://\* {github,gitlab}.com/\* bitbucket.org/\*
            case \*/\*
                set name "github.com/$name"
            case \*
                echo "cannot install \"$name\" without a prefix -- should be <owner>/$name" >&2
                continue
        end

        echo $name | command awk '{
            split($0, tmp, /@/)

            pkg = tmp[1]
            tag = tmp[2] ? tmp[2] : "master"
            name = tmp[split(pkg, tmp, "/")]

            print (\
                pkg ~ /^github\.com/ ? "https://codeload."pkg"/tar.gz/"tag : \
                pkg ~ /^gitlab\.com/ ? "https://"pkg"/-/archive/"tag"/"name"-"tag".tar.gz" : \
                pkg ~ /^bitbucket\.org/ ? "https://"pkg"/get/"tag".tar.gz" : pkg \
            ) "\t" pkg
        }' | read -l url pkg

        if test ! -d "$fisher_config/$pkg"
            fish -c "
                echo fetching $url >&2
                command mkdir -p \"$fisher_config/$pkg\"

                if curl -Ss $url 2>&1 | tar -xzf- -C \"$fisher_config/$pkg\" --strip-components=1 2>/dev/null
                    command mkdir -p \"$fisher_cache/$pkg\"
                    command cp -Rf \"$fisher_config/$pkg\" \"$fisher_cache/$pkg/..\"
                else if test -d \"$fisher_cache/$pkg\"
                    echo cannot connect to server -- using data from \"$fisher_cache/$pkg\" | command sed 's|$HOME|~|' >&2
                    command cp -Rf \"$fisher_cache/$pkg\" \"$fisher_config/$pkg/..\"
                else
                    command rm -rf \"$fisher_config/$pkg\"
                    echo cannot install \"$pkg\" -- are you offline\? >&2
                end
            " >/dev/null &

            set pkg_jobs $pkg_jobs (_fisher_jobs --last)
            set expected_pkgs $expected_pkgs "$pkg"
        end
    end

    if test ! -z "$pkg_jobs"
        _fisher_wait $pkg_jobs
        for pkg in $expected_pkgs
            if test -d "$fisher_config/$pkg"
                set actual_pkgs $actual_pkgs $pkg
                _fisher_pkg_install $fisher_config/$pkg
            end
        end
    end

    for pkg in $local_pkgs
        set -l path local/$USER
        set -l name (command basename $pkg)

        command mkdir -p $fisher_config/$path
        command ln -sf $pkg $fisher_config/$path

        set actual_pkgs $actual_pkgs $path/$name
        _fisher_pkg_install $fisher_config/$path/$name
    end

    if test ! -z "$actual_pkgs"
        _fisher_pkg_fetch_all (_fisher_pkg_get_deps $actual_pkgs | command sort --unique)
        printf "%s\n" $actual_pkgs
    end
end

function _fisher_pkg_get_deps
    for pkg in $argv
        set -l path $fisher_config/$pkg
        if test ! -d "$path"
            echo $pkg
        else if test -s "$path/fishfile"
            _fisher_pkg_get_deps (_fisher_fishfile_indent < $path/fishfile | _fisher_fishfile_load)
        end
    end
end

function _fisher_pkg_install -a pkg
    set -l name (command basename $pkg)
    set -l files $pkg/{functions,completions,conf.d}/* $pkg/*.fish
    for source in $files
        set -l target (command basename $source)
        switch $source
            case $pkg/conf.d\*
                set target $fisher_path/conf.d/$target
            case $pkg/completions\*
                set target $fisher_path/completions/$target
            case $pkg/{functions,}\*
                switch $target
                    case uninstall.fish
                        continue
                    case init.fish key_bindings.fish
                        set target $fisher_path/conf.d/$name\_$target
                    case \*
                        set target $fisher_path/functions/$target
                end
        end
        echo "linking $target" | command sed "s|$HOME|~|" >&2
        command ln -f $source $target
        switch $target
            case \*.fish
                source $target >/dev/null 2>/dev/null
        end
    end
end

function _fisher_pkg_uninstall -a pkg
    set -l name (command basename $pkg)
    set -l files $pkg/{conf.d,completions,functions}/* $pkg/*.fish
    for source in $files
        set -l target (command basename $source)
        set -l filename (command basename $target .fish)
        switch $source
            case $pkg/conf.d\*
                test "$filename.fish" = "$target"; and emit "$filename"_uninstall
                set target conf.d/$target
            case $pkg/completions\*
                test "$filename.fish" = "$target"; and complete -ec $filename
                set target completions/$target
            case $pkg/{,functions}\*
                test "$filename.fish" = "$target"; and functions -e $filename
                switch $target
                    case uninstall.fish
                        source $source
                        continue
                    case init.fish key_bindings.fish
                        set target conf.d/$name\_$target
                    case \*
                        set target functions/$target
                end
        end
        command rm -f $fisher_path/$target
    end
    if not functions -q fish_prompt
        source "$__fish_datadir$__fish_data_dir/functions/fish_prompt.fish"
    end
end

function _fisher_fishfile_indent -a pkgs
    command awk -v PWD=$PWD -v HOME=$HOME -v PKGS="$pkgs" '
        function normalize(s) {
            gsub(/^[ \t]*|[ \t]*$|https?:\/\/|github\.com\/|\.git$|\/$/, "", s)
            sub(/^\.\//, PWD"/", s)
            sub(HOME, "~", s)
            return s
        }
        function get_pkg_name(s) {
            split(s, tmp, /[@# ]+/)
            return tmp[1]
        }
        BEGIN {
            pkg_count = split(PKGS, pkgs, ";") - 1
            cmd = pkgs[1]
            for (i = 2; i <= pkg_count; i++) {
                pkg_ids[i - 1] = get_pkg_name( pkgs[i] = normalize(pkgs[i]) )
            }
        } {
            if (NF) {
                nl = nl > 0 ? "" : nl
                pkg_id = get_pkg_name( $0 = normalize($0) )
                if (/^#/) print nl$0
                else if (!seen[pkg_id]++) {
                    for (i = 1; i < pkg_count; i++) {
                        if (pkg_ids[i] == pkg_id) {
                            if (cmd == "rm") next
                            $0 = pkgs[i + 1]
                            break
                        }
                    }
                    print nl$0
                }
                nl = NF
            } else if (nl) nl = (nl > 0 ? "" : nl)"\n"
        }
        END {
            if (cmd == "rm" || pkg_count <= 1) exit
            for (i = 2; i <= pkg_count; i++) {
                if (!seen[pkg_ids[i - 1]]) print pkgs[i]
            }
        }
    '
end

function _fisher_fishfile_load
    command awk -v FS=\# '!/^#/ && NF { print $1 }'
end

function _fisher_status_report
    command awk '
        function msg(res, str, n) {
            return (res ? res ", " : "") str " " n " package" (n > 1 ? "s" : "")
        }
        $1 = $1 - $2 { res = msg(res, "added", $1) }
                  $2 { res = msg(res, "updated", $2) }
        $3 = $3 - $2 { res = msg(res, "removed", $3) }
                     { printf((res ? res : "done") " in %.2fs\n", ($4 / 1000)) }
    '
end

function _fisher_jobs
    jobs $argv | command awk '/[0-9]+\t/ { print $1 }'
end

function _fisher_wait
    while for job in $argv
            contains -- $job (_fisher_jobs); and break
        end
    end
end
