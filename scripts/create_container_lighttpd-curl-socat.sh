#!/bin/sh

DESCRIPTION="A container with lighttpd in it - extended by curl and socat (UDS)"
CONTAINER_NAME="lighttpd_container-curl-socat"
ROOTFS_LIST="lighttpd-curl-socat.txt"

PACKAGES="${PACKAGES} Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES} busybox-1.24.2.sh"
PACKAGES="${PACKAGES} finit-1.10.sh"
PACKAGES="${PACKAGES} zlib-1.2.11.sh"
PACKAGES="${PACKAGES} dropbear-2016.73.sh"
PACKAGES="${PACKAGES} timezone2016e.sh"
PACKAGES="${PACKAGES} mcip.sh"
PACKAGES="${PACKAGES} pcre-8.38.sh"
PACKAGES="${PACKAGES} metalog-3.sh"
PACKAGES="${PACKAGES} ncurses-6.0.sh"
PACKAGES="${PACKAGES} nano-2.6.0.sh"
PACKAGES="${PACKAGES} openssl-1.0.2h.sh"
PACKAGES="${PACKAGES} libxml2-2.9.4.sh"
PACKAGES="${PACKAGES} sqlite-src-3110100.sh"
PACKAGES="${PACKAGES} gdbm-1.12.sh"
PACKAGES="${PACKAGES} lighttpd-1.4.39.sh"
#add for curl and socat:
PACKAGES="${PACKAGES} curl-7.49.1.sh"
PACKAGES="${PACKAGES} socat-2.0.0-b9.sh"

SCRIPTSDIR="$(dirname $0)"
TOPDIR="$(realpath ${SCRIPTSDIR}/..)"
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo " "
echo "###################################################################################################"
echo " This creates "$DESCRIPTION
echo " A SSH server runs within the container - expecting your login as root/root"
echo "###################################################################################################"
echo " "
echo "It is necessary to build these Open Source projects in this order:"
for PACKAGE in ${PACKAGES} ; do echo "- ${PACKAGE}"; done
echo " "
echo "These packages only have to be compiled once. 
echo "  Hit 'y' to build all packages from scratch. "
echo "  Hit 'n' to simply create the container from exisiting packages."

read text
if [ "${text}" = "y" -o "${text}" = "yes" ] 
then # compile the needed packages
    for PACKAGE in ${PACKAGES} ; do
        echo ""
        echo "*************************************************************************************"
        echo "* downloading, checking, configuring, compiling and installing ${PACKAGE%.sh}"
        echo "*************************************************************************************"
        echo ""
           ${OSS_PACKAGES_SCRIPTS}/${PACKAGE}          
        all || exit
    done
fi

# package container
echo ""
echo "*************************************************************************************"
echo "* Packaging the container  "$CONTAINER_NAME
echo "*************************************************************************************"
echo ""
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
