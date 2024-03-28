#!/bin/bash

set -eux

TEST=${TEST:-"dataplane-deploy-no-nodes-test"}
TIMEOUT=${TIMEOUT:-"120"}
KUTTL_ARGS="--test ${TEST} --timeout ${TIMEOUT}"

if [ "${SKIP_DELETE}" = "1" ]; then
    KUTTL_ARGS="${KUTTL_ARGS} --skip-delete"
fi

oc project openstack
oc delete netconfig/netconfig --ignore-not-found
oc delete dnsmasq/dns --ignore-not-found
oc delete osdpnodeset --all
oc delete osdpdeployments --all
make kuttl-test KUTTL_ARGS="${KUTTL_ARGS}"
