#!/bin/bash

set -eux

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CSV_OPERATOR=${CSV_OPERATOR:-"openstack"}
OPERATOR=${OPERATOR:-"openstack"}
CONTROLLER_MANAGER=${CONTROLLER_MANAGER:-"${OPERATOR}-operator-controller-manager"}
SCALE=${SCALE:-0}
CSV_VERSION=${CSV_VERSION:-"v0.0.1"}

source ${SCRIPT_DIR}/common.sh

oc project openstack-operators

INDEX=$(oc get csv ${CSV_OPERATOR}-operator.${CSV_VERSION} -o json | jq ".spec.install.spec.deployments | map(.name==\"${CONTROLLER_MANAGER}\") | index(true)")

if [ ${INDEX} != "null" ]; then
    oc patch csv ${CSV_OPERATOR}-operator.${CSV_VERSION} --type='json' -p='[{"op": "replace", "path": "/spec/install/spec/deployments/'${INDEX}'/spec/replicas", "value":'${SCALE}'}]'
else
    echored "${CONTROLLER_MANAGER} not found in ${CSV_OPERATOR} csv"
fi

oc project openstack
