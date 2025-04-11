#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}

export IMAGE_TAG_BASE=${IMAGE_TAG_BASE:-"quay.io/jslagle/openstack-ansibleee-runner"}
export IMAGE_TAG=${IMAGE_TAG:-"latest"}

error() {
    echo "ERROR"
    popd
}
trap error ERR

if ! grep quay.io ${XDG_RUNTIME_DIR}/containers/auth.json; then
    podman login quay.io
fi

make openstack_ansibleee_build
make openstack_ansibleee_push
