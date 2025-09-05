#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))
export DEEPSCRUB=${DEEPSCRUB:-""}
export CIFMW_DIR=${CIFMW_DIR:-"${HOME}/ci-framework"}

if [ "${DEEPSCRUB}" = "1" ]; then
    DEEPSCRUB_ARGS="--tags deepscrub"
    sudo rm -rf /home/zuul/ci-framework-data
else
    DEEPSCRUB_ARGS=""
fi

pushd ${CIFMW_DIR}

ansible-playbook -i custom/inventory.yml \
    -e cifmw_target_host=hypervisor-1 \
    reproducer-clean.yml \
    ${DEEPSCRUB_ARGS}

popd
