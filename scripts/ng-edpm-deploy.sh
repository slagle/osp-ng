#!/bin/bash

set -eux

export NODES=${NODES:-"2"}
export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls

if [ ${NODES} = "2" ]; then
    export DATAPLANE_SINGLE_NODE=false
fi

make edpm_deploy
popd
