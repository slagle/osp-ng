#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))
export FLUSH_CACHE=${FLUSH_CACHE:-"--flush-cache"}
export RRIP=${RRIP:-""}
export CIFMW_DIR=${CIFMW_DIR:-"${OPENSTACK_K8S_OPERATORS}/ci-framework"}
export DOWNSTREAM=${DOWNSTREAM:-"1"}
export DEPLOY_ARCHITECTURE=${DEPLOY_ARCHITECTURE:-"true"}

if [ -z "${RRIP}" ]; then
    echo "\${RRIP} MUST BE SET TO redhat.registry.io PASSWORD!"
    exit 1
fi

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/ci-framework ]; then
    git clone https://github.com/openstack-k8s-operators/ci-framework ${CIFMW_DIR}
fi

pushd ${CIFMW_DIR}

if [ ! -d "${HOME}/test-python" ]; then
  echo "make setup_molecule needs to be run from ${CIFMW_DIR}"
  echo "cd ${CIFMW_DIR}"
  echo "make setup_molecule"
  exit 1
fi

source ${HOME}/test-python/bin/activate

if [ "${DOWNSTREAM}" = "1" ]; then
  DOWNSTREAM_ARGS="-e @${NG_PRIVATE_DIR}/ci-framework/custom/downstream-vars.yml"
else
  DOWNSTREAM_ARGS=""
fi

cp ${NG_DIR}/ci-framework/custom/inventory.yml custom/inventory.yml
sed -i "s/HOST/$(hostname)/" custom/inventory.yml

rm -rf ~/ansible.log;
ansible-playbook \
  reproducer.yml \
  -i custom/inventory.yml \
  -e @scenarios/reproducers/va-hci.yml \
  -e @scenarios/reproducers/networking-definition.yml \
  -e @${NG_PRIVATE_DIR}/ci-framework/custom/default-vars.yml \
  ${DOWNSTREAM_ARGS} \
  -e @${NG_DIR}/ci-framework/custom/secrets.yml \
  -e cifmw_target_host=hypervisor-1 \
  -e cifmw_deploy_architecture=${DEPLOY_ARCHITECTURE} \
  -e cifmw_nolog=false \
  -e registry_redhat_io_password=${RRIP} \
  ${FLUSH_CACHE} \
  $@

popd
