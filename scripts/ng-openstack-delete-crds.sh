#!/bin/bash

set -eux

crds=$(oc get --no-headers crd | grep -E 'openstack|rabbitmq' | cut -d' ' -f1)
if [ "${crds}" != "" ]; then
    oc delete --ignore-not-found --wait=false crd ${crds}
fi
