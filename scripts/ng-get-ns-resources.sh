#!/bin/bash

NAMESPACE=${NAMESPACE:-"openstack"}

oc api-resources --verbs=list --namespaced -o name | xargs -n 1 oc get --show-kind --ignore-not-found -n ${NAMESPACE}
