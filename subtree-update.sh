#!/bin/bash -x

# pull from remote for a configured subtree

prefix="$(cd ${1:-.} && git rev-parse --show-prefix)"
prefix="${prefix:-$1}"
prefix=${prefix%/}

cd "$(git rev-parse --show-toplevel)"

mname=$(git config -f .gitsubtrees --get "subtree.$prefix.remote")
mpath=$(git config -f .gitsubtrees --get "subtree.$prefix.path")
mbranch=$(git config -f .gitsubtrees --get "subtree.$prefix.branch")
mbranch=${mbranch:-master}

git fetch $mname
git subtree pull -P "$mpath" "$mname" "$mbranch" --squash
