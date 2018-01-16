#Script for quick release of new revision,
#i.e. version maj.min.rev+1.
#Revision from debian changelog will be incremented
#and a comment passed as argument is added.

#!/bin/bash

#we want exit immediately if any command fails and we want error in piped commands to be preserved
set -eo pipefail

if [[ -z "$1" ]]; then
    echo -e "Error: comment as argument expected"
    exit 1
fi

git pull
if [[ $? -ne 0 ]]; then exit 1; fi



version=$(myci-deb-version.sh debian/changelog)

#echo $version

rev=$(echo $version | sed -n -e 's/^[0-9]*\.[0-9]*\.\([0-9]*\)$/\1/p')
majmin=$(echo $version | sed -n -e 's/^\([0-9]*\.[0-9]*\.\)[0-9]*$/\1/p')

#echo rev = $rev
#echo majmin = $majmin

newver=$majmin$((rev + 1))

#echo newver = $newver

if [[ -z ${DEBEMAIL+x} ]]; then echo "error: DEBEMAIL is unset"; exit 1; fi
if [[ -z ${DEBFULLNAME+x} ]]; then echo "error: DEBFULLNAME is unset"; exit 1; fi

dch -v"$newver" "$1"
if [[ $? -ne 0 ]]; then exit 1; fi

dch -r -D unstable ""
if [[ $? -ne 0 ]]; then exit 1; fi

git commit -a -m"release $newver"
if [[ $? -ne 0 ]]; then exit 1; fi

git push
if [[ $? -ne 0 ]]; then exit 1; fi

git tag $newver
if [[ $? -ne 0 ]]; then exit 1; fi

#git tag -f latest

git push -f --tags
if [[ $? -ne 0 ]]; then exit 1; fi
