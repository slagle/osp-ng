#!/bin/bash

set -eux

oc -n openstack-operators get pods $@
