#!/bin/bash

set -eux

oc login -u kubeadmin -p 12345678 --insecure-skip-tls-verify https://api.crc.testing:6443
