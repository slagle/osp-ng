#!/bin/bash

set -eux

export SCRIPTS_DIR=$(dirname $(realpath $0))

oc project openstack || :

delete_namespace() {
    oc delete --ignore-not-found --wait=false namespace $1

    while true; do
    if oc get namespace $1; then
        sleep 2
    else
        break
    fi
    done
}

delete_namespace openstack
delete_namespace openstack-operators
