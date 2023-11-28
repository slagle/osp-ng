#!/bin/bash

set -eux

oc project openstack || :

crds=$(oc get --no-headers crd | grep -E 'openstack|rabbitmq' | cut -d' ' -f1)

delete_crs () {
    crs=$(oc get --no-headers ${1} | cut -d' ' -f1)
    for cr in ${crs}; do
       oc patch ${1} ${cr} --type='json' -p='[{"op": "remove", "path": "/metadata/finalizers"}]'
       oc delete --ignore-not-found ${1} ${cr}
    done
}

for crd in ${crds}; do
    delete_crs ${crd} &
done

wait
