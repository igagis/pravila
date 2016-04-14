#Script for quick release of new revision,
#i.e. version maj.min.rev+1.
#Revision from debian changelog will be incremented
#and a comment passed as argument is added.

#!/bin/bash

if [[ -z "$1" ]]; then
    echo -e "Error: comment as argument expected"
    exit 1
fi


version=$(prorab-deb-version.sh debian/changelog)

#echo $version

rev=$(echo $version | sed -n -e 's/^[0-9]*\.[0-9]*\.\([0-9]*\)$/\1/p')
majmin=$(echo $version | sed -n -e 's/^\([0-9]*\.[0-9]*\.\)[0-9]*$/\1/p')

#echo rev = $rev
#echo majmin = $majmin

newver=$majmin$((rev + 1))

#echo newver = $newver

dch -v"$newver" "$1"

dch -r -D stable ""

git pull
git commit -a -m"release $newver"
git push
git tag $newver
git push --tags
