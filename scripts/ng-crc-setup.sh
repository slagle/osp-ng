#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export CRC_DELETE=${CRC_DELETE:-"1"}
export CRC_RESET=${CRC_RESET:-"0"}
export DOWNLOAD_TOOLS=${DOWNLOAD_TOOLS:-"1"}
export CPUS=${CPUS:-"16"}
export MEMORY=${MEMORY:-"32768"}
export DISK=${DISK:-"80"}

export PULL_SECRET=${PULL_SECRET:-${HOME}/pull-secret.json}

if [ ! -f "${PULL_SECRET}" ]; then
    echo "Pull secret does not exist at ${PULL_SECRET}."
    echo "Set \${PULL_SECRET} to the correct path for the pull secret."
    exit 1
fi

if [ "$(basename $0)" = "ng-crc-reset.sh" ]; then
    CRC_DELETE=0
    DOWNLOAD_TOOLS=0
    CRC_RESET=1
fi

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls ${OPENSTACK_K8S_OPERATORS}/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls

if ! which git; then
    sudo dnf -y install git
fi
if ! which make; then
    sudo dnf -y install make
fi
if ! which ansible-playbook; then
    sudo dnf -y install ansible-core
fi


pushd devsetup

if [ "${CRC_RESET}" = "1" ]; then
    make crc_cleanup
fi

if [ "${CRC_DELETE}" = "1" ]; then
    make crc_cleanup
    make crc_scrub
fi

if [ "${DOWNLOAD_TOOLS}" = "1" ]; then
    make download_tools
fi

make crc
eval $(crc oc-env)
make crc_attach_default_interface

popd

make crc_storage

popd
