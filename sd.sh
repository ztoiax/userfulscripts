#!/bin/bash
# This is a script with download singel file or folder in github

if ! echo $1 | grep blob &> /dev/null;then
    link=$(echo $1 | sed "s/tree\/master/trunk/")
    svn checkout $link
else
    link=$(echo $1 | sed "s/github.com/raw.githubusercontent.com/")
    link=$(echo $link | sed "s/\/blob\//\//")
    curl -LO $link
fi
