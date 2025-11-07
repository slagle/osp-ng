#!/bin/bash

set -eux

# PASS=$(ssh -t controller-0 cat .kube/kubeadmin-password || :)
DEVSCRIPTS_PASS=$(cat /home/${DEVSCRIPTS_USER:-"zuul"}/src/github.com/openshift-metal3/dev-scripts/ocp/ocp/auth/kubeadmin-password)

oc login -u kubeadmin -p ${DEVSCRIPTS_PASS} https://api.ocp.openstack.lab:6443
