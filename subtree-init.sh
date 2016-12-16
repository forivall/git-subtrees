#!/bin/bash -x

# add remote for a configured subtree

prefix="$(cd ${1:-.} && git rev-parse --show-prefix)"
prefix=${prefix%/}

mname=$(git config -f .gitsubtrees --get "subtree.$prefix.remote")
murl=$(git config -f .gitsubtrees --get "subtree.$prefix.url")
git remote add -f $mname $murl
