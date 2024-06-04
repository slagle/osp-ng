#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export NODES=${NODES:-"1"}
export DATAPLANE_TOTAL_NODES=${DATAPLANE_TOTAL_NODES:-"$NODES"}

if ! which virt-customize; then
    sudo dnf -y install guestfs-tools
fi

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls ${OPENSTACK_K8S_OPERATORS}/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls
cd devsetup

# If let evaluates to 0, it returns 1, which would fail the script
let idx=${NODES}-1 || :

for n in $(seq 0 ${idx}); do
    EDPM_COMPUTE_SUFFIX=$n make edpm_compute
done

popd
