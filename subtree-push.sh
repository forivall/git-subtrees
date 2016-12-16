#!/bin/bash -x

# pull from remote for a configured subtree

prefix="$(cd ${1:-.} && git rev-parse --show-prefix || echo $1) "
prefix=${prefix%/}

mname=$(git config -f .gitsubtrees --get "subtree.$prefix.remote")
mpath=$(git config -f .gitsubtrees --get "subtree.$prefix.path")
mbranch=$(git config -f .gitsubtrees --get "subtree.$prefix.branch")
mbranch=${mbranch:master}

git fetch $mname
git subtree pull -P $mpath $mname --squash
