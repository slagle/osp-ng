#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export ANSIBLE_ROLES_PATH=${OPENSTACK_K8S_OPERATORS}/ci-framework/roles
export APPLY_BMH=${APPLY_BMH:-"false"}
export BM_INFO=${BM_INFO:-""}

ANSIBLE_ARGS=""
if [ -n "${BM_INFO}" ]; then
  ANSIBLE_ARGS="-e baremetal_info=$(realpath ${BM_INFO})"
fi

ansible-playbook \
  -i controller-0, \
  -e apply_bmh=${APPLY_BMH} \
  ${NG_DIR}/ci-framework/playbooks/deploy_bmh.yml \
  $ANSIBLE_ARGS \
  $@

oc patch provisioning provisioning-configuration --type merge -p '{"spec":{"watchAllNamespaces": true }}'
