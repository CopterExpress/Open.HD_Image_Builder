log "Checking prerequisites"

if [ ! -d ~/tools ]; then
    log "Download the Raspberry Pi Tools"
    git clone https://github.com/raspberrypi/tools ~/tools
    log "Install the Raspberry Pi Tools"
    echo PATH=\$PATH:~/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin >> ~/.bashrc
    source ~/.bashrc
fi

DEBIAN_FRONTEND=noninteractive apt-get -yq update
DEBIAN_FRONTEND=noninteractive apt-get -yq install flex bison libssl-dev
