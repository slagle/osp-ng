#!/bin/bash

SCRIPT_DIR=$(realpath $(dirname $(basename $0)))

set -eux

pushd ${SCRIPT_DIR}
sphinx-build . _build/
popd
