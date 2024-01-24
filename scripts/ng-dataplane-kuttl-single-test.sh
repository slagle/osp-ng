#!/bin/bash

set -eux

TEST=${TEST:-"dataplane-deploy-no-nodes-test"}
TIMEOUT=${TIMEOUT:-"120"}
SKIP_DELETE=${SKIP_DELETE:-"--skip-delete"}

oc project openstack
oc delete netconfig/netconfig --ignore-not-found
oc delete dnsmasq/dns --ignore-not-found
oc delete osdpnodeset --all
oc delete osdpdeployments --all
make kuttl-test KUTTL_ARGS="--test ${TEST} --timeout ${TIMEOUT} ${SKIP_DELETE}"
