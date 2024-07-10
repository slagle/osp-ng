#!/bin/bash

set -eux

oc project openstack || :

crds=$(oc get --no-headers crd | grep -E 'openstack|rabbitmq' | cut -d' ' -f1)

patch_and_delete () {
   oc patch ${1} ${2} --type='json' -p='[{"op": "remove", "path": "/metadata/finalizers"}]' || :
   oc delete --ignore-not-found ${1} ${2}
}

delete_crs () {
    crs=$(oc get --no-headers ${1} | cut -d' ' -f1)
    for cr in ${crs}; do
		patch_and_delete ${1} ${cr} &
    done
}

for crd in ${crds}; do
    delete_crs ${crd} &
done

delete_crs configmap
delete_crs secret
delete_crs service
delete_crs pvc

wait
