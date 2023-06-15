#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"install_yamls"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

if [ ! -d ${OPENSTACK_K8S_OPERATORS} ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls

make openstack_deploy_cleanup
make openstack_cleanup

popd
