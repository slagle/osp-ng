#!/bin/bash

set -eux

export INSTALL_YAMLS=${INSTALL_YAMLS:-"install_yamls"}
export NODES=${NODES:-"1"}

if [ ! -d $INSTALL_YAMLS ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls $INSTALL_YAMLS
fi

if [ ${NODES} = "2" ]; then
    export DATAPLANE_SINGLE_NODE=false
fi

pushd $INSTALL_YAMLS
make edpm_deploy
popd
