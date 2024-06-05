#!/bin/bash

set -eux

TEST=${TEST:-"dataplane-deploy-no-nodes-test"}
TIMEOUT=${TIMEOUT:-"120"}
SKIP_DELETE=${SKIP_DELETE:-"0"}
KUTTL_ARGS="--test ${TEST} --timeout ${TIMEOUT}"

if [ "${SKIP_DELETE}" = "1" ]; then
    KUTTL_ARGS="${KUTTL_ARGS} --skip-delete"
fi

oc project openstack
oc delete osdpnodeset --all
oc delete osdpdeployments --all
make kuttl-test KUTTL_ARGS="${KUTTL_ARGS}"
