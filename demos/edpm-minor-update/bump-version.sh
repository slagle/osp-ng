#!/bin/bash
set -eux

# bump version to 18.0.1
# set initial version to 18.0.0
NEW_VERSION=18.0.1
CSV_OPERATOR=openstack
CONTROLLER_MANAGER=openstack-operator-controller-manager
INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments | map(.name==\"${CONTROLLER_MANAGER}\") | index(true)")
CONTAINERS_INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments[${INDEX}].spec.template.spec.containers | map(.name==\"manager\") | index(true)")
ENV_INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments[${INDEX}].spec.template.spec.containers[${CONTAINERS_INDEX}].env | map(.name==\"OPENSTACK_RELEASE_VERSION\") | index(true)")
oc -n openstack-operators patch csv ${CSV_OPERATOR}-operator.v0.0.1 --type='json' -p='[{"op": "replace", "path": "/spec/install/spec/deployments/'${INDEX}'/spec/template/spec/containers/'${CONTAINERS_INDEX}'/env/'${ENV_INDEX}'/value", "value":'${NEW_VERSION}'}]'
# bump ovn-controller image
OVN_IMAGE=quay.io/jslagle/openstack-ovn-controller:18.0.1
OVN_ENV_INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments[${INDEX}].spec.template.spec.containers[${CONTAINERS_INDEX}].env | map(.name==\"RELATED_IMAGE_OVN_CONTROLLER_IMAGE_URL_DEFAULT\") | index(true)")
oc -n openstack-operators patch csv ${CSV_OPERATOR}-operator.v0.0.1 --type='json' -p='[{"op": "replace", "path": "/spec/install/spec/deployments/'${INDEX}'/spec/template/spec/containers/'${CONTAINERS_INDEX}'/env/'${OVN_ENV_INDEX}'/value", "value":'${OVN_IMAGE}'}]'
