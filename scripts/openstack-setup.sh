#!/bin/bash

set -eux

export INSTALL_YAMLS=${INSTALL_YAMLS:-"install_yamls"}

if [ ! -d $INSTALL_YAMLS ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls $INSTALL_YAMLS
fi

pushd $INSTALL_YAMLS

# make openstack

i=0
while ! oc get crd openstackcontrolplanes.core.openstack.org; do
    sleep 1
    ((i++))
    if [ $i -gt 30 ]; then
        echo "openstackcontrolplanes.core.openstack.org CRD not ready after 30 seconds"
        exit 1
    fi
done

make openstack_deploy

popd
