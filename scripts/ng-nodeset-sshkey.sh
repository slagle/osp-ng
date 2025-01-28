#!/bin/bash

set -eux

NODESET=${NODESET:-"openstack-edpm-ipam"}
SECRET=${SECRET:-"$(oc get osdpns ${NODESET} -o json | jq -r .spec.nodeTemplate.ansibleSSHPrivateKeySecret)"}
WRITE=${WRITE:-"0"}

if [ "$WRITE" = "1" ]; then
    oc get secret ${SECRET} -o json | jq -r '.data["ssh-privatekey"]' | base64 -d > ${OPENSTACK_K8S_OPERATORS}/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa
    oc get secret ${SECRET} -o json | jq -r '.data["ssh-publickey"]' | base64 -d > ${OPENSTACK_K8S_OPERATORS}/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa.pub
    chmod 0600 ${OPENSTACK_K8S_OPERATORS}/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa
    chmod 0600 ${OPENSTACK_K8S_OPERATORS}/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa.pub
else
    oc get secret ${SECRET} -o json | jq -r '.data["ssh-privatekey"]' | base64 -d
    oc get secret ${SECRET} -o json | jq -r '.data["ssh-publickey"]' | base64 -d
fi
