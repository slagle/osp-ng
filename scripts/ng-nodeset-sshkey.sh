#!/bin/bash

set -eux

NODESET=${NODESET:-"openstack-edpm-ipam"}
SECRET=${SECRET:-"$(oc get osdpns ${NODESET} -o json | jq -r .spec.nodeTemplate.ansibleSSHPrivateKeySecret)"}

oc get secret ${SECRET} -o json | jq -r '.data["ssh-privatekey"]' | base64 -d
