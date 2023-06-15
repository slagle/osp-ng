#!/bin/bash

set -eux

export SCRIPTS_DIR=$(dirname $(realpath $0))

oc project openstack || :

${SCRIPTS_DIR}/openstack-delete.sh
${SCRIPTS_DIR}/openstack-delete-crs.sh
${SCRIPTS_DIR}/openstack-delete-crds.sh
${SCRIPTS_DIR}/openstack-delete-namespaces.sh
