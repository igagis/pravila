#!/bin/bash

#This script releases the current version.
#It changes the debian record to unstable release
#And pushes the release to git repo adding the release tag.

#we want exit immediately if any command fails and we want error in piped commands to be preserved
set -eo pipefail

git pull
if [[ $? -ne 0 ]]; then
    echo "error: git pull failed"
    exit 1;
fi


version=$(myci-deb-version.sh debian/changelog)

#echo $version

if [[ -z ${DEBEMAIL+x} ]]; then echo "error: DEBEMAIL is unset"; exit 1; fi
if [[ -z ${DEBFULLNAME+x} ]]; then echo "error: DEBFULLNAME is unset"; exit 1; fi

dch -r -D unstable ""
if [[ $? -ne 0 ]]; then
    echo "dch -r failed"
    exit 1;
fi

git commit -a -m"release $version"
if [[ $? -ne 0 ]]; then
    echo "error: git commit failed"
    exit 1;
fi

git push
if [[ $? -ne 0 ]]; then
    echo "error: git push failed"
    exit 1;
fi

git checkout -B release
[ $? -ne 0 ] && echo "error: git cehckout -B release failed" && exit 1;

git merge master
[ $? -ne 0 ] && echo "error: git merge master failed" && exit 1;

git push --set-upstream origin release
[ $? -ne 0 ] && echo "error: git push --set-upstream origin release failed" && exit 1;

git tag $version
if [[ $? -ne 0 ]]; then
    echo "error: git tag failed"
    exit 1;
fi

git push --tags
if [[ $? -ne 0 ]]; then
    echo "error: git push --tags failed"
    exit 1;
fi

git checkout master
[ $? -ne 0 ] && echo "error: git checkout master failed" && exit 1;
