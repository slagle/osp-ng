#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))
export CIFMW_DIR=${CIFMW_DIR:-"${OPENSTACK_K8S_OPERATORS}/ci-framework"}

if [ ! -d "${CIFMW_DIR}" ]; then
    pushd ${OPENSTACK_K8S_OPERATORS}
    git clone https://github.com/openstack-k8s-operators/ci-framework
    popd
fi

pushd ${CIFMW_DIR}

make setup_molecule
source ${HOME}/test-python/bin/activate

curl -o bootstrap-hypervisor.yml https://gitlab.cee.redhat.com/ci-framework/docs/-/raw/main/sources/files/bootstrap-hypervisor.yml

ansible-playbook -i custom/inventory.yml \
  -e ansible_user=root \
  -e cifmw_target_host=hypervisor-1 \
  bootstrap-hypervisor.yml

popd
