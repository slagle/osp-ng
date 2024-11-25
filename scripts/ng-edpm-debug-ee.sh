#!/bin/bash

DEPLOYMENT=${DEPLOYMENT:-"edpm-deployment-ipam"}
NODESET=${NODESET:-"openstack-edpm-ipam"}
SERVICE=${SERVICE:-"run-os"}

echo "#################"
echo "/opt/builder/bin/edpm_entrypoint ansible-runner run /runner -p osp.edpm.${SERVICE} -i ${SERVICE}-${DEPLOYMENT}-${NODESET}"
echo "#################"
oc debug --as-root --keep-annotations job/${SERVICE}-${DEPLOYMENT}-${NODESET}
