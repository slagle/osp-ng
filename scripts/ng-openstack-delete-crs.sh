#!/bin/bash

set -eux

NAMESPACE=${NAMESPACE:-"openstack"}
oc project ${NAMESPACE} || :

crds=$(oc get --no-headers crd | grep -E 'openstack|rabbitmq|mariadb' | cut -d' ' -f1)

patch_and_delete () {
   oc patch -n ${3} ${1} ${2} --type='json' -p='[{"op": "remove", "path": "/metadata/finalizers"}]' || :
   oc delete -n ${3} --ignore-not-found ${1} ${2}
}

delete_crs () {
    namespace=${2:-"${NAMESPACE}"}
    crs=$(oc get -n ${namespace} --no-headers ${1} | cut -d' ' -f1)
    for cr in ${crs}; do
		patch_and_delete ${1} ${cr} ${namespace} &
    done
}

for crd in ${crds}; do
    delete_crs ${crd} &
done

delete_crs openstack openstack-operators
delete_crs configmap
delete_crs secret
delete_crs service
delete_crs pvc

wait
