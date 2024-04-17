#!/bin/bash

set -eux

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
VERSION=18.0.0 /home/jslagle/code/osp-ng/osp-ng/demos/edpm-minor-update/set-version.sh
# oc -n openstack-operators get pods --selector openstack.org/operator-name=openstack -w # get controller-manager
# oc -n openstack-operators wait pods --selector openstack.org/operator-name=openstack --for delete
oc patch openstackversion openstack-galera-network-isolation --type='json' -p='[{"op": "replace", "path": "/spec/targetVersion", "value": "18.0.0"}]'
oc delete osdpd ovn-update --ignore-not-found # delete deploy, delete ovn-update deploy
oc apply -f ~/code/osp-ng/osp-ng/demos/edpm-minor-update/deployments/ovn-update.yml
oc wait openstackdataplanedeployment ovn-update --for condition=Ready --timeout 60s
oc delete osdpd ovn-update

${SCRIPT_DIR}/check.sh
