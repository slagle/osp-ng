#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls ${OPENSTACK_K8S_OPERATORS}/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls

oc project openstack || :

${SCRIPTS_DIR}/ng-openstack-delete.sh
${SCRIPTS_DIR}/ng-openstack-delete-crs.sh
${SCRIPTS_DIR}/ng-openstack-delete-crds.sh
${SCRIPTS_DIR}/ng-openstack-delete-operators.sh
${SCRIPTS_DIR}/ng-openstack-delete-namespaces.sh
${SCRIPTS_DIR}/ng-pv-reclaim.sh

make crc_storage_cleanup
make crc_storage

popd
