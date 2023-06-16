#!/bin/bash

set -eux

oc patch openstackdataplane openstack-edpm  -p='[{"op": "replace", "path": "/spec/deployStrategy/deploy", "value":false}]' --type json; oc patch openstackdataplane openstack-edpm  -p='[{"op": "replace", "path": "/spec/deployStrategy/deploy", "value":true}]' --type json
