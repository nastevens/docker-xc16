###############################################################################
# Dockerfile to build a container with the Microchip XC16 compiler and
# PIC24/dsPIC peripheral libraries installed.
###############################################################################

FROM debian:jessie
MAINTAINER Nick Stevens <nick@bitcurry.com>

WORKDIR /tmp

# Microchip tools require i386 compatability libs
RUN dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y libc6:i386

# Download and install XC16 compiler and peripheral libraries
# Chain commands to reduce the size of this (already large) image
RUN buildDeps='curl' \
    && set -x \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $buildDeps \
    && curl -fSL -A "Mozilla/4.0" "http://www.microchip.com/mymicrochip/filehandler.aspx?ddocname=en558868" -o xc16.run \
    && curl -fSL -A "Mozilla/4.0" "http://www.microchip.com/mymicrochip/filehandler.aspx?ddocname=en574961" -o plib.run \
    && chmod +x xc16.run \
    && chmod +x plib.run \
    && ./xc16.run \
        --prefix /opt/microchip/xc16 \
        --mode unattended \
        --unattendedmodeui none \
        --netservername localhost \
        --LicenseType FreeMode \
    && ./plib.run \
        --prefix /opt/microchip/xc16 \
        --mode unattended \
        --unattendedmodeui none \
    && DEBIAN_FRONTEND=noninteractive apt-get purge -y --auto-remove $buildDeps \
    && DEBIAN_FRONTEND=noninteractive apt-get clean \
    && rm -f xc16.run plib.run
