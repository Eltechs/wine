#!/bin/bash

WINEVERSION=1.8.1-4eltechs
TOPTOPDIR=$1

function create_build_dir
{
    rm -f .gitattributes
    
    TOPDIR=${TOPTOPDIR}/${MEMSPLIT}
    DEBIANDIR="debian-${MEMSPLIT}"

    mkdir -p ${TOPDIR}/wine-build
    echo 'prepare-deb-package-dir.sh export-ignore' > .gitattributes

    git archive HEAD --format=tar --worktree-attributes -o ${TOPDIR}/wine-build/debian.tar ${DEBIANDIR}
    echo "debian-mem2g export-ignore" >> .gitattributes
    echo "debian-mem3g export-ignore" >> .gitattributes    
    git archive HEAD --format=tar.gz  --worktree-attributes -o ${TOPDIR}/wine_${WINEVERSION}.orig.tar.gz 

    rm -rf .gitattributes

    tar -xf ${TOPDIR}/wine-build/debian.tar --directory=${TOPDIR}/wine-build
    mv ${TOPDIR}/wine-build/${DEBIANDIR} ${TOPDIR}/wine-build/debian
    tar -xzf ${TOPDIR}/wine_${WINEVERSION}.orig.tar.gz --directory=${TOPDIR}/wine-build/
    
    rm ${TOPDIR}/wine-build/debian.tar
}

MEMSPLIT='mem2g'
create_build_dir
MEMSPLIT='mem3g'
create_build_dir







