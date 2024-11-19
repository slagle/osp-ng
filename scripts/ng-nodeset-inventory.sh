#!/bin/bash

set -eux

NODESET=${NODESET:-"openstack-edpm-ipam"}

oc get secret dataplanenodeset-${NODESET} -o json | jq -r .data.inventory | base64 -d
