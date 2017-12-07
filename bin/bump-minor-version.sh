#Script for quick bumping up the minor version,
#i.e. version maj.min+1.0.
#Minor version from debian changelog will be incremented
#and a comment passed as argument is added.

#!/bin/bash

#we want exit immediately if any command fails and we want error in piped commands to be preserved
set -eo pipefail

if [[ -z "$1" ]]; then
    echo -e "Error: comment as argument expected"
    exit 1
fi


version=$(myci-deb-version.sh debian/changelog)

#echo $version

maj=$(echo $version | sed -n -e 's/^\([0-9]*\)\.[0-9]*\.[0-9]*$/\1/p')
min=$(echo $version | sed -n -e 's/^[0-9]*\.\([0-9]*\)\.[0-9]*$/\1/p')
rev=$(echo $version | sed -n -e 's/^[0-9]*\.[0-9]*\.\([0-9]*\)$/\1/p')

echo maj = $maj
echo min = $min
echo rev = $rev

newver=$maj.$((min+1)).0

echo newver = $newver

if [[ -z ${DEBEMAIL+x} ]]; then echo "error: DEBEMAIL is unset"; exit 1; fi
if [[ -z ${DEBFULLNAME+x} ]]; then echo "error: DEBFULLNAME is unset"; exit 1; fi

dch -v"$newver" "$1"
if [[ $? -ne 0 ]]; then exit 1; fi
