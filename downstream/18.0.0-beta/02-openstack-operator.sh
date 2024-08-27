#!/bin/bash

set -eux

REGISTRY=default-route-openshift-image-registry.apps-crc.testing
# namespace must match a project name
REGISTRY_NAMESPACE=openstack-operators
INDEX_IMAGE=$REGISTRY/$REGISTRY_NAMESPACE/rhoso-operator-index:1.0.0

cat > openstack-operator.yaml <<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: openstack-operator-index
  namespace: openstack-operators
spec:
  sourceType: grpc
  image: $INDEX_IMAGE
---
apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: openstack
  namespace: openstack-operators
---
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openstack-operator
  namespace: openstack-operators
spec:
  name: openstack-operator
  channel: alpha
  source: openstack-operator-index
  sourceNamespace: openstack-operators
EOF

oc apply -f openstack-operator.yaml
