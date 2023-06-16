#!/bin/bash

set -eux

oc login -u kubeadmin -p 12345678 https://api.crc.testing:6443
