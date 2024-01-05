#!/bin/bash

set -eux

CSV_OPERATOR=${CSV_OPERATOR:-"openstack"}
OPERATOR=${OPERATOR:-"dataplane"}
CONTROLLER_MANAGER=${CONTROLLER_MANAGER:-"${OPERATOR}-operator-controller-manager"}
SCALE=${SCALE:-0}

oc project openstack-operators

INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments | map(.name==\"${CONTROLLER_MANAGER}\") | index(true)")

oc patch csv ${CSV_OPERATOR}-operator.v0.0.1 --type='json' -p='[{"op": "replace", "path": "/spec/install/spec/deployments/'${INDEX}'/spec/replicas", "value":'${SCALE}'}]'

oc project openstack
