#!/bin/bash

TOPDIR=$1
WINEVERSION=1.8.1

rm -f .gitattributes
mkdir -p ${TOPDIR}/wine-build
echo 'prepare-deb-package-dir.sh export-ignore' > .gitattributes

git archive HEAD --format=tar --worktree-attributes -o ${TOPDIR}/wine-build/debian.tar debian
echo 'debian export-ignore' >> .gitattributes
git archive HEAD --format=tar.gz  --worktree-attributes -o ${TOPDIR}/wine_${WINEVERSION}.orig.tar.gz 

rm -f .gitattributes

tar -xf ${TOPDIR}/wine-build/debian.tar --directory=${TOPDIR}/wine-build
tar -xzf ${TOPDIR}/wine_${WINEVERSION}.orig.tar.gz --directory=${TOPDIR}/wine-build/
rm ${TOPDIR}/wine-build/debian.tar







