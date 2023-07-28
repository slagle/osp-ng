#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export WAIT_SECONDS=${WAIT_SECONDS:-"60"}

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls ${OPENSTACK_K8S_OPERATORS}/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls

i=0
while ! oc get crd openstackcontrolplanes.core.openstack.org; do
    sleep 1
    ((i++))
    if [ $i -gt ${WAIT_SECONDS} ]; then
        echo "openstackcontrolplanes.core.openstack.org CRD not ready after ${WAIT_SECONDS} seconds"
        exit 1
    fi
done

make openstack_deploy

popd
