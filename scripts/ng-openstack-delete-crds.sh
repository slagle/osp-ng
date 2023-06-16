#!/bin/bash

set -eux

export INSTALL_YAMLS=${INSTALL_YAMLS:-"install_yamls"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

crds=$(oc get --no-headers crd | grep -E 'openstack|rabbitmq' | cut -d' ' -f1)
if [ "${crds}" != "" ]; then
    oc delete --ignore-not-found --wait=false crd ${crds}
fi
