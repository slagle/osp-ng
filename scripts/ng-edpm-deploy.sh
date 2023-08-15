#!/bin/bash

set -eux

export NODES=${NODES:-"1"}
export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))
export DATAPLANE_CHRONY_NTP_SERVER=${DATAPLANE_CHRONY_NTP_SERVER:-"clock.redhat.com"}

if [ "$0" = "ng-edpm-deploy-prep.sh" ]; then
    DEPLOY=0
else
    DEPLOY=1
fi

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls ${OPENSTACK_K8S_OPERATORS}/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls

if [ ${NODES} = "1" ]; then
    export DATAPLANE_SINGLE_NODE=true
else
    export DATAPLANE_SINGLE_NODE=false
fi

if [ "${DEPLOY}" = "0" ]; then
    make edpm_deploy_prep
else
    make edpm_deploy
fi

popd
