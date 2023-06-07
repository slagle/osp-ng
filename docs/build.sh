#!/bin/bash

DOCS_DIR=$(realpath $(dirname $(basename $0))/docs)

set -eux

pushd ${DOCS_DIR}
sphinx-build . _build/
popd
