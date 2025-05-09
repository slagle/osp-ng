#!/bin/bash

set -eux

DEPLOYMENT=${DEPLOYMENT:-"edpm-deployment"}
NODESET=${NODESET:-"openstack-edpm-ipam"}
SERVICE=${SERVICE:-"run-os"}
IMAGE=${IMAGE:-""}

echo "#################"
echo "/opt/builder/bin/edpm_entrypoint ansible-runner run /runner -p osp.edpm.${SERVICE/-/_} -i ${SERVICE}-${DEPLOYMENT}-${NODESET}"
echo "#################"

if [ "${IMAGE}" != "" ]; then
    IMAGE_ARG="--image ${IMAGE}"
else
    IMAGE_ARG=""
fi

oc debug --as-root --keep-annotations \
    ${IMAGE_ARG} \
    job/${SERVICE}-${DEPLOYMENT}-${NODESET} \
    -- /bin/bash
