#!/bin/bash -x

cd ${0%/*}/.. || exit

# extract the list of submodules from .gitmodule

set -e

git config -f .gitmodules --get-regexp 'submodule\..*'|cut -d. -f2|sort|uniq |while read s
do
    echo converting $s

    # extract the module's prefix
    mpath=$(git config -f .gitmodules --get "submodule.$s.path")

    # extract the url of the submodule
    murl=$(git config -f .gitmodules --get "submodule.$s.url")

    # extract the module name
    mname=$(basename $murl)

    # deinit the module
    git submodule deinit $mpath

    # remove the module from git
    git rm -r --cached $mpath

    # remove the module from the filesystem
    rm -rf $mpath

    # commit the change
    git commit -m "Removed $mpath submodule"

    # add the remote
    git remote add -f $mname $murl || true

    # add the subtree
    git subtree add --prefix $mpath $mname master --squash

    # fetch the files
    git fetch $murl master

    # update the .gitsubtrees config file

    git config -f .gitmodules --remove-section "submodule.$s"
    git config -f .gitsubtrees --add "subtree.$s.path" $mpath
    git config -f .gitsubtrees --add "subtree.$s.url" $murl
    git config -f .gitsubtrees --add "subtree.$s.remote" $mname

    git add .gitmodules .gitsubtrees
    if (( $(wc -c < .gitmodules) == 0 )) ; then
        git rm --force .gitmodules
    fi
    git commit -m "chore: update .gitsubtrees file ($mname)

$s"
done
