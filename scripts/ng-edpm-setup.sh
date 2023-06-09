#!/bin/bash

set -eux

export INSTALL_YAMLS=${INSTALL_YAMLS:-"install_yamls"}
export NODES=${NODES:-"1"}

if ! which virt-customize; then
    sudo dnf -y install guestfs-tools
fi

if [ ! -d $INSTALL_YAMLS ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls $INSTALL_YAMLS
fi

pushd $INSTALL_YAMLS
cd devsetup

let idx=${NODES}-1
for n in $(seq 0 ${idx}); do
    EDPM_COMPUTE_SUFFIX=$n make edpm_compute
    EDPM_COMPUTE_SUFFIX=$n make edpm_compute_repos
done

popd
