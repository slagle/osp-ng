#!/bin/bash

set -eux

PASS=$(ssh -t controller-0 cat .kube/kubeadmin-password)
oc login -u kubeadmin -p $PASS https://api.ocp.openstack.lab:6443
