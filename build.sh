#!/bin/bash

echo Get version of latest glibc...
VERSION=$(dnf --disablerepo=* --enablerepo=fedora,updates list --available glibc.x86_64 | grep fc29 | awk '{print $2}')

echo Make some folders...
rm -rf rpmbuild
mkdir rpmbuild
cd rpmbuild
mkdir SRPMS
mkdir SOURCES
mkdir SPECS
cd SRPMS

echo Downloading glibc srpm version $VERSION
wget https://dl.fedoraproject.org/pub/fedora/linux/updates/29/Everything/SRPMS/Packages/g/glibc-$VERSION.src.rpm

echo Unpack the srpm...
cd ../SOURCES
rpm2cpio ../SRPMS/glibc-$VERSION.src.rpm | cpio -idmv
mv glibc.spec ../SPECS
cd ..

echo Apply the patch...
cp ../glibc-Revert-elf-Correct-absolute-SHN_ABS-symbol-run-time.patch SOURCES
../process-spec-file.py

echo Build the SRPM...
TOPDIR=$(pwd)
rpmbuild --define "_topdir $TOPDIR" -bs SPECS/glibc.spec

