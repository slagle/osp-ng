#!/bin/bash
set -eux

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${SCRIPT_DIR}/set-indexes.sh

oc -n openstack-operators get csv openstack-operator.v0.0.1 -o yaml | yq .spec.install.spec.deployments[${INDEX}].spec.template.spec.containers[${CONTAINERS_INDEX}].env[${ENV_INDEX}]

oc -n openstack-operators get csv openstack-operator.v0.0.1 -o yaml | yq .spec.install.spec.deployments[${INDEX}].spec.template.spec.containers[${CONTAINERS_INDEX}].env[${OVN_ENV_INDEX}]

ssh -t stack@host06.beaker.tripleo.ral3.eng.rdu2.redhat.com ssh -t -i openstack-k8s-operators/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100 podman ps | grep ovn_controller

