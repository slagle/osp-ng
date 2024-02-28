#!/bin/bash

set -eux

OPERATOR=${OPERATOR:-"openstack"}
WEBHOOK_NAMES=${WEBHOOK_NAMES:-"mopenstackdataplanenodeset.kb.io vopenstackdataplanenodeset.kb.io"}

oc project openstack-operators

for name in ${WEBHOOK_NAMES}; do
    index=$(oc get csv ${OPERATOR}-operator.v0.0.1 -o json | jq ".spec.webhookdefinitions | map(.generateName==\"${name}\") | index(true)")
    oc patch csv ${OPERATOR}-operator.v0.0.1 --type='json' -p='[{"op": "remove", "path": "/spec/webhookdefinitions/'${index}'"}]'
done
