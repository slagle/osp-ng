#!/bin/bash

set -eux

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
VERSION_NAME=${VERSION_NAME:-"openstack-galera-network-isolation"}
IMAGE_TAG_BASE=${IMAGE_TAG_BASE:-"quay.io/jslagle/openstack-ansibleee-runner"}
IMAGE_TAG=${IMAGE_TAG:-"latest"}

source ${SCRIPT_DIR}/common.sh

oc project openstack

oc patch openstackversion ${VERSION_NAME} --type='json' -p='[{"op": "replace", "path": "/spec/customContainerImages/ansibleeeImage", "value":'${IMAGE_TAG_BASE}:${IMAGE_TAG}'}]'