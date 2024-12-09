#!/bin/bash

set -eux

source ${NG_DIR}/../local-dataplane-rc

make bundle
make bundle-build
make bundle-push

make catalog-build
make catalog-push

make docker-build
make docker-push
