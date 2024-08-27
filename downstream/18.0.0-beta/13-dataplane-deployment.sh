#!/bin/bash

set -eux

cat > dataplane-libvirt-secret.yaml << EOF
apiVersion: v1
data:
 LibvirtPassword: cGFzc3dvcmQ=
kind: Secret
metadata:
 name: libvirt-secret
 namespace: openstack
type: Opaque
EOF

cat > dataplane-deployment.yaml << EOF
apiVersion: dataplane.openstack.org/v1beta1
kind: OpenStackDataPlaneDeployment
metadata:
  name: deployment
  namespace: openstack
spec:
  nodeSets:
  - nodeset
EOF

oc apply -f dataplane-libvirt-secret.yaml
oc apply -f dataplane-deployment.yaml
