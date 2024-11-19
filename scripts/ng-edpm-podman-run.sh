#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

if [ ! -f ${NG_DIR}/gitignored/inventory ]; then
    ${SCRIPTS_DIR}/ng-nodeset-inventory.sh > ${NG_DIR}/gitignored/inventory
fi

if [ ! -f ${NG_DIR}/gitignored/ssh_key ]; then
    ${SCRIPTS_DIR}/ng-nodeset-sshkey.sh > ${NG_DIR}/gitignored/ssh_key
fi

pushd ${OPENSTACK_K8S_OPERATORS}/edpm-ansible

podman run -it \
    -v ${OPENSTACK_K8S_OPERATORS}/edpm-ansible:/usr/share/ansible/collections/ansible_collections/osp/edpm:rw \
    -v ${NG_DIR}/gitignored/inventory:/runner/inventory/inventory:rw \
    -v ${NG_DIR}/gitignored/ssh_key:/runner/env/ssh_key/ssh_key:rw \
    -v ${NG_DIR}/scripts/ng-edpm-runner-run.sh:/opt/ng-edpm-runner-run.sh:rw,z \
    localhost/edpm-ansible:latest \
    /bin/bash

popd
