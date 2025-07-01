#!/bin/bash

set -eux

export NODES=${NODES:-"1"}
export DATAPLANE_TOTAL_NODES=${NODES}
export OPENSTACK_K8S_OPERATORS=${OPENSTACK_K8S_OPERATORS:-"$(pwd)"}
export SCRIPTS_DIR=$(dirname $(realpath $0))
export DATAPLANE_NTP_SERVER=${DATAPLANE_NTP_SERVER:-"clock.redhat.com"}

export OUT=${OUT:-"${OPENSTACK_K8S_OPERATORS}/install_yamls/out"}
export NAMESPACE=${NAMESPACE:-"openstack"}
export DEPLOY_DIR=${OUT}/${NAMESPACE}/dataplane/cr

if [ "$(basename $0)" = "ng-edpm-deploy-prep.sh" ]; then
    DEPLOY=0
else
    DEPLOY=1
fi

if [ -d "${DEPLOY_DIR}" ] && [ "${DEPLOY}" = "0" ]; then
    mv ${DEPLOY_DIR}/../../dataplane ${OUT}/${NAMESPACE}/dataplane-$(date +%s)
fi

if [ ! -d ${OPENSTACK_K8S_OPERATORS}/install_yamls ]; then
    git clone https://github.com/openstack-k8s-operators/install_yamls ${OPENSTACK_K8S_OPERATORS}/install_yamls
fi

pushd ${OPENSTACK_K8S_OPERATORS}/install_yamls


if [ "${DEPLOY}" = "0" ]; then
    make edpm_deploy_prep
else
    # make edpm_deploy
    oc apply -f devsetup/edpm/config/ansible-ee-env.yaml
    oc kustomize ${DEPLOY_DIR} | oc apply -f -
fi

popd
