#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))
export FLUSH_CACHE=${FLUSH_CACHE:-"--flush-cache"}
export RRIP=${RRIP:-""}
export CIFMW_DIR=${CIFMW_DIR:-"${HOME}/ci-framework"}
export DOWNSTREAM=${DOWNSTREAM:-"1"}

if [ -z "${RRIP}" ]; then
    echo "\${RRIP} MUST BE SET TO redhat.registry.io PASSWORD!"
    exit 1
fi

pushd ${CIFMW_DIR}

if [ "${DOWNSTREAM}" = "1" ]; then
  DOWNSTREAM_ARGS="-e @${NG_DIR}/ci-framework/custom/downstream-vars.yml"
else
  DOWNSTREAM_ARGS=""
fi

rm -rf ~/ansible.log;
ansible-playbook \
  reproducer.yml \
  -i ${NG_DIR}/ci-framework/custom/inventory.yml \
  -e @scenarios/reproducers/va-hci.yml \
  -e @scenarios/reproducers/networking-definition.yml \
  -e @${NG_DIR}/ci-framework/custom/default-vars.yml \
  ${DOWNSTREAM_ARGS} \
  -e @${NG_DIR}/ci-framework/custom/secrets.yml \
  -e cifmw_target_host=hypervisor-1 \
  -e cifmw_deploy_architecture=true \
  -e cifmw_nolog=false \
  -e registry_redhat_io_password=${RRIP} \
  ${FLUSH_CACHE} \
  $@

popd
