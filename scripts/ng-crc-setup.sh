#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export CRC_SCRUB=${CRC_SCRUB:-"1"}
export CRC_CLEANUP=${CRC_CLEANUP:-"0"}
# 2.41.0 corresponds to OCP 4.16.7
# https://mirror.openshift.com/pub/openshift-v4/clients/crc/2.41.0/
export CRC_VERSION=${CRC_VERSION:-"2.41.0"}
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
    CRC_SCRUB=0
    DOWNLOAD_TOOLS=0
    CRC_CLEANUP=1
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

if [ "${CRC_CLEANUP}" = "1" ]; then
    make crc_cleanup || :
fi

if [ "${CRC_SCRUB}" = "1" ]; then
    make crc_scrub || :
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

# Fix chrony clock source
ng-crc-ssh.sh sed 's/pool.*/pool\ clock.redhat.com\ iburst/' /etc/chrony.conf

echo "#############################################"
echo "You probably want to run:"
echo "make openstack"
echo "make openstack_init"
echo "ng-crc-deploy.sh"
echo "#############################################"