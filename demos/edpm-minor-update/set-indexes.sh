#!/bin/bash
set -eux

CSV_OPERATOR=openstack
CONTROLLER_MANAGER=openstack-operator-controller-manager
INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments | map(.name==\"${CONTROLLER_MANAGER}\") | index(true)")
CONTAINERS_INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments[${INDEX}].spec.template.spec.containers | map(.name==\"manager\") | index(true)")
ENV_INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments[${INDEX}].spec.template.spec.containers[${CONTAINERS_INDEX}].env | map(.name==\"OPENSTACK_RELEASE_VERSION\") | index(true)")

OVN_ENV_INDEX=$(oc get csv ${CSV_OPERATOR}-operator.v0.0.1 -o json | jq ".spec.install.spec.deployments[${INDEX}].spec.template.spec.containers[${CONTAINERS_INDEX}].env | map(.name==\"RELATED_IMAGE_OVN_CONTROLLER_IMAGE_URL_DEFAULT\") | index(true)")
