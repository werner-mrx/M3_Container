#! /bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="http://mosquitto.org/files/source/mosquitto-1.4.10.tar.gz"
PKG_DOWNLOAD="http://mosquitto.org/files/source/mosquitto-1.4.10.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="61839b47b58c5799aab76584f13ed66f"

# name of directory after extracting the archive in working directory
PKG_DIR="mosquitto-1.4.10"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="mosquitto-1.4.10.tar.gz"

SCRIPTSDIR="$(dirname $0)"
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR="$(realpath ${SCRIPTSDIR}/../..)"

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    true
}

compile()
{
    copy_overlay
    echo "${PKG_BUILD_DIR}"
    cd "${PKG_BUILD_DIR}"
    
    export CFLAGS="${M3_CFLAGS}  -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS}  -L${STAGING_LIB} -lcrypto -lssl"
    
    make ${M3_MAKEFLAGS}
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make prefix="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}


. ${HELPERSDIR}/call_functions.sh
