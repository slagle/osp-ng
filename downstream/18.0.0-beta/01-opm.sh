#!/bin/bash

set -eux

REGISTRY=default-route-openshift-image-registry.apps-crc.testing
# namespace must match a project name
REGISTRY_NAMESPACE=openstack-operators
INDEX_IMAGE=$REGISTRY/$REGISTRY_NAMESPACE/rhoso-operator-index:1.0.0

# Will need to login if using $BETA_BUNDLES
# podman login registry.redhat.io
BETA_BUNDLES="\
registry.redhat.io/rhoso-podified-beta/openstack-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/swift-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/glance-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/infra-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/ironic-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/keystone-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/ovn-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/placement-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/telemetry-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/heat-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/cinder-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/manila-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/neutron-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/nova-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-edpm-beta/openstack-ansibleee-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/mariadb-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/openstack-baremetal-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/rabbitmq-cluster-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/horizon-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/octavia-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/barbican-operator-bundle:1.0.0,\
registry.redhat.io/rhoso-podified-beta/designate-operator-bundle:1.0.0\
"

# Generated with:
# oc get installplan -o yaml | yq .items[0].status.bundleLookups[].path | awk -F 1.0.0 '{printf $1 "1.0.0,\\\n"}'
REGISTRY_PROXY_BUNDLES="\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-manila-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-telemetry-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-barbican-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-ovn-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-heat-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-infra-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-nova-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-edpm-trunk-openstack-ansibleee-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-rabbitmq-cluster-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-designate-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-ironic-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-keystone-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-octavia-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-openstack-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-openstack-baremetal-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-horizon-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-glance-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-cinder-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-neutron-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-swift-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-placement-operator-bundle:1.0.0,\
registry-proxy.engineering.redhat.com/rh-osbs/rhoso-podified-trunk-mariadb-operator-bundle:1.0.0\
"

BUNDLES=${BUNDLES:-"${REGISTRY_PROXY_BUNDLES}"}

oc registry login --insecure=true

opm index add -u podman --pull-tool podman --tag $INDEX_IMAGE \
    --mode semver \
    --bundles "${BUNDLES}"

podman push --tls-verify=false $INDEX_IMAGE
