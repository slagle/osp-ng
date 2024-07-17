#!/bin/bash

set -eux

oc get operator -o name | grep openstack | xargs -t -n 1 oc delete
