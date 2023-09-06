#!/bin/bash

set -eux

export SCRIPTS_DIR=$(dirname $(realpath $0))

oc project openstack || :

${SCRIPTS_DIR}/ng-openstack-delete.sh
${SCRIPTS_DIR}/ng-openstack-delete-crs.sh
${SCRIPTS_DIR}/ng-openstack-delete-crds.sh
${SCRIPTS_DIR}/ng-openstack-delete-namespaces.sh
${SCRIPTS_DIR}/ng-pv-reclaim.sh
