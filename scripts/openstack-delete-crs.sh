#!/bin/bash

set -eux

export INSTALL_YAMLS=${INSTALL_YAMLS:-"install_yamls"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

crds=$(oc get --no-headers crd | grep -E 'openstack|rabbitmq' | cut -d' ' -f1)
if [ "${crds}" != "" ]; then
    oc delete --ignore-not-found --wait=false crd ${crds}
fi

patch_crs() {
    crs=$(oc get --no-headers ${1} | cut -d' ' -f1)
    for cr in ${crs}; do
       oc patch ${1} ${cr} --type='json' -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
    done
}

for crd in ${crds}; do
    patch_crs ${crd} &
done

wait

oc delete --ignore-not-found --wait=false namespace openstack

oc get namespace openstack
