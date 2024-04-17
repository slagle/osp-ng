#!/bin/bash
set -eux

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
VERSION=${VERSION:-"18.0.1"}

if [ "${VERSION}" = "18.0.1" ]; then
    OPENSTACK_RELEASE_VERSION=${OPENSTACK_RELEASE_VERSION:-"18.0.1"}
    RELATED_IMAGE_OVN_CONTROLLER_IMAGE_URL_DEFAULT=${RELATED_IMAGE_OVN_CONTROLLER_IMAGE_URL_DEFAULT:-"quay.io/jslagle/openstack-ovn-controller:18.0.1"}
fi

if [ "${VERSION}" = "18.0.0" ]; then
    OPENSTACK_RELEASE_VERSION=${OPENSTACK_RELEASE_VERSION:-"18.0.0"}
    RELATED_IMAGE_OVN_CONTROLLER_IMAGE_URL_DEFAULT=${RELATED_IMAGE_OVN_CONTROLLER_IMAGE_URL_DEFAULT:-"quay.io/podified-antelope-centos9/openstack-ovn-controller@sha256:c69cc2600ebc88e548710651a40bfc4ea6368176d23bd6620fee7f812b286a93"}
fi

# Set $OPENSTACK_RELEASE_VERSION
oc -n openstack-operators patch csv ${CSV_OPERATOR}-operator.v0.0.1 --type='json' -p='[{"op": "replace", "path": "/spec/install/spec/deployments/'${INDEX}'/spec/template/spec/containers/'${CONTAINERS_INDEX}'/env/'${ENV_INDEX}'/value", "value":'${OPENSTACK_RELEASE_VERSION}'}]'

# Set $RELATED_IMAGE_OVN_CONTROLLER_IMAGE_URL_DEFAULT
oc -n openstack-operators patch csv ${CSV_OPERATOR}-operator.v0.0.1 --type='json' -p='[{"op": "replace", "path": "/spec/install/spec/deployments/'${INDEX}'/spec/template/spec/containers/'${CONTAINERS_INDEX}'/env/'${OVN_ENV_INDEX}'/value", "value":'${RELATED_IMAGE_OVN_CONTROLLER_IMAGE_URL_DEFAULT}'}]'

# Print result
${SCRIPT_DIR}/check.sh
