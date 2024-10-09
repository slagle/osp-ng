#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export CRC_DELETE=${CRC_DELETE:-"0"}
export CPUS=${CPUS:-"16"}
export MEMORY=${MEMORY:-"32768"}
export DISK=${DISK:-"80"}

export PULL_SECRET=${PULL_SECRET:-${HOME}/pull-secret.json}

if [ ! -f "${PULL_SECRET}" ]; then
    echo "Pull secret does not exist at ${PULL_SECRET}."
    echo "Set \${PULL_SECRET} to the correct path for the pull secret."
    exit 1
fi

if [ "${CRC_DELETE}" = "1" ]; then
    rm -f ~/bin/crc
    rm -rf ~/.crc
fi

if ! which git; then
    sudo dnf -y install git
fi
if ! which make; then
    sudo dnf -y install make
fi
if ! which ansible-playbook; then
    sudo dnf -y install ansible-core
fi

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls ${OPENSTACK_K8S_OPERATORS}/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls

cd devsetup
make download_tools
make crc
eval $(crc oc-env)
make crc_attach_default_interface
cd ..

make crc_storage

popd
