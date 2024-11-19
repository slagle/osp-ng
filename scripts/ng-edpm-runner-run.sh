#!/bin/bash

set -eux

export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))

/opt/builder/bin/edpm_entrypoint \
    /usr/local/bin/ansible-runner \
    run \
    /runner \
    --cmdline "\-e ansible_ssh_private_key_file=/runner/env/ssh_key/ssh_key" \
    --inventory /runner/inventory/inventory \
    $@
