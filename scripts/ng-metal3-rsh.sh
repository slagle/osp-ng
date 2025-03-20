#!/bin/bash

set -eux

CONTAINER=${CONTAINER:-"mariadb"}

oc rsh  -n baremetal-operator-system -c ${CONTAINER} $(oc get pods -n baremetal-operator-system -o name | grep ironic)