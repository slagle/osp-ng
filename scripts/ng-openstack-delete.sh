#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls ${OPENSTACK_K8S_OPERATORS}/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls

# install_yamls approach
# make openstack_deploy_cleanup
# make openstack_cleanup

oc project openstack
oc delete oscps --all=true
oc delete openstack --all=true
oc delete osdpns --all=true
oc delete osdpd --all=true
oc delete osdps --all=true

oc project openstack-operators
oc delete subscription --all=true
oc delete csv --all=true
oc delete catalogsource --all=true

popd
