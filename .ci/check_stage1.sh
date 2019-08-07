#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

KERNELCACHE_REPO="https://github.com/CopterExpress/openhd_kernels"
KERNELCACHE_DIR=$(pwd)/openhd_kernels
KERNEL_VERSION=$(git log --format=%h -1 stages/00-Prerequisites stages/01-Baseimage stages/02-Kernel config)
KERNEL_FILE=kernel_${KERNEL_VERSION}.img.xz
KERNEL_STAMP_FILE=stamp_${KERNEL_VERSION}

echo "Cloning cache repository"

git clone ${KERNELCACHE_REPO} ${KERNELCACHE_DIR}

echo "Checking for stamp file in repo"

if [[ -z $(find ${KERNELCACHE_DIR} -name ${KERNEL_STAMP_FILE}  ) ]]; then
    echo "No stamp file in repo, proceeding with build"
else
    echo "Stamp file in repo, checking for release"
    sudo apt-get update
    sudo apt-get -y install wget curl
    # wget used to produce empty files on failure; use curl instead
    #wget --progress=dot:giga -O "${KERNEL_FILE}" "${KERNELCACHE_REPO}/releases/download/${KERNEL_STAMP_FILE}/${KERNEL_FILE}"
    curl --fail --location "${KERNELCACHE_REPO}/releases/download/${KERNEL_STAMP_FILE}/${KERNEL_FILE}" -o "${KERNEL_FILE}"
    if [[ -f "${KERNEL_FILE}" ]]; then
        echo "Kernel already built, skipping build"
        export SKIP_BUILD=1
    else
        echo "Stamp file exists in the repo, but no build is made; rebuilding"
    fi
fi
