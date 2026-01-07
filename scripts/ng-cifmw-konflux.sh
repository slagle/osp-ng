#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))
export AUTHFILE=${AUTHFILE:-"/tmp/authfile"}

oc get \
    -n openshift-config \
    secret/pull-secret \
    -o json | jq -r '.data.".dockerconfigjson"' | base64 -d > ${AUTHFILE}

podman login \
    --authfile ${AUTHFILE} \
    --username "${REGISTRY_STAGE_USER}" \
    --password "${REGISTRY_STAGE_PASS}" \
    ${REGISTRY_STAGE}

oc set \
    data secret/pull-secret \
    -n openshift-config \
    --from-file=.dockerconfigjson=${AUTHFILE}

oc apply -f ${NG_PRIVATE_DIR}/crs/registry-stage-icsp.yaml
# oc apply -f ${NG_PRIVATE_DIR}/crs/registry-stage-cs.yaml