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
    echo "No stamp file in repo"
    pushd ${KERNELCACHE_DIR}
    echo "Built from ${KERNEL_VERSION}" > ${KERNEL_STAMP_FILE}

    git config --local user.name "sfalexrog"
    git config --local user.email "sfalexrog@gmail.com"
    git add ${KERNEL_STAMP_FILE}
    git commit -m "Added ${KERNEL_STAMP_FILE}"

    git tag -a ${KERNEL_STAMP_FILE} -m "Built from ${KERNEL_VERSION}"
    git push "https://sfalexrog:${GITHUB_OAUTH_TOKEN}@github.com/CopterExpress/openhd_kernels"
    git push "https://sfalexrog:${GITHUB_OAUTH_TOKEN}@github.com/CopterExpress/openhd_kernels" --tags


    echo "Installing deployment prerequisites"

    sudo apt-get update
    sudo apt-get install -y --no-install-recommends python3-dev

    wget https://bootstrap.pypa.io/get-pip.py
    sudo python3 ./get-pip.py
    sudo pip install pygithub

    echo "Uploading image"

    popd

    PYTHONUNBUFFERED=1 ${SCRIPT_DIR}/upload_stage1.py "openhd_kernels" ${KERNEL_STAMP_FILE} ${KERNEL_FILE}
else
    echo "Stamp file already in repo, skipping deployment"
fi
