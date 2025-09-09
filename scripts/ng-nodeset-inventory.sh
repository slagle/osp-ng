#!/bin/bash

set -eux

NODESET=${NODESET:-"openstack-edpm-ipam"}
NAMESPACE=${NAMESPACE:-"openstack"}

oc -n ${NAMESPACE} get secret dataplanenodeset-${NODESET} -o json | jq -r .data.inventory | base64 -d
