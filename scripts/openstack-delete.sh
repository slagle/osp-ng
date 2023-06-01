#!/bin/bash

set -eux

export INSTALL_YAMLS=${INSTALL_YAMLS:-"install_yamls"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

if [ ! -d $INSTALL_YAMLS ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls $INSTALL_YAMLS
fi

pushd $INSTALL_YAMLS

make openstack_deploy_cleanup
make openstack_cleanup
