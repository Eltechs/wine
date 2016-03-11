#!/bin/bash

TOPDIR=$1
WINEVERSION=1.8.1


mkdir -p ${TOPDIR}/wine-build
git archive HEAD --format=tar.gz  --worktree-attributes -o ${TOPDIR}/wine_${WINEVERSION}.orig.tar.gz 
git archive --format=tar HEAD -o ${TOPDIR}/wine-build/debian.tar debian
tar -xf ${TOPDIR}/wine-build/debian.tar --directory=${TOPDIR}/wine-build
tar -xzf ${TOPDIR}/wine_${WINEVERSION}.orig.tar.gz --directory=${TOPDIR}/wine-build/
rm ${TOPDIR}/wine-build/debian.tar







