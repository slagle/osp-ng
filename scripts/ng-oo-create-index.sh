#!/bin/bash

set -eux

VERSION=${VERSION:-"18.0.2"}
PULLSPECS=${PULLSPECS:-"https://download.engineering.redhat.com/rcm-guest/puddles/OpenStack/rhoso-18.0-CI-files/pullspecs-${VERSION}.txt"}
BUNDLES="$(curl ${PULLSPECS})"

REGISTRY=default-route-openshift-image-registry.apps-crc.testing
# namespace must match a project name
REGISTRY_NAMESPACE=openstack-operators
INDEX_IMAGE=$REGISTRY/$REGISTRY_NAMESPACE/rhoso-operator-index:1.0.0

oc registry login --insecure=true

opm index add -u podman --pull-tool podman --tag $INDEX_IMAGE \
    --mode semver \
    --bundles "${BUNDLES}"

podman push --tls-verify=false $INDEX_IMAGE
