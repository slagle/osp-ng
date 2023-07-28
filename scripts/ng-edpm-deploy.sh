#!/bin/bash

set -eux

export NODES=${NODES:-"1"}
export INSTALL_YAMLS=${INSTALL_YAMLS:-"install_yamls"}
export SCRIPTS_DIR=$(dirname $(realpath $0))
export DATAPLANE_CHRONY_NTP_SERVER=${DATAPLANE_CHRONY_NTP_SERVER:-"clock.redhat.com"}

if [ ! -d $INSTALL_YAMLS ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls
fi

pushd $INSTALL_YAMLS

if [ ${NODES} = "2" ]; then
    export DATAPLANE_SINGLE_NODE=false
fi

make edpm_deploy
popd
