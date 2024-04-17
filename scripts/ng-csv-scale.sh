#!/bin/bash

set -eux

SCRIPT_DIR=$(realpath $(dirname $(basename $0)))
CSV_OPERATOR=${CSV_OPERATOR:-"openstack"}
OPERATOR=${OPERATOR:-"dataplane"}
CONTROLLER_MANAGER=${CONTROLLER_MANAGER:-"${OPERATOR}-operator-controller-manager"}
SCALE=${SCALE:-0}

source ${SCRIPT_DIR}/common.sh

oc project openstack-operators

INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments | map(.name==\"${CONTROLLER_MANAGER}\") | index(true)")

if [ ${INDEX} != "null" ]; then
    oc patch csv ${CSV_OPERATOR}-operator.v0.0.1 --type='json' -p='[{"op": "replace", "path": "/spec/install/spec/deployments/'${INDEX}'/spec/replicas", "value":'${SCALE}'}]'
else
    echored "${CONTROLLER_MANAGER} not found in ${CSV_OPERATOR} csv"
fi

oc project openstack
