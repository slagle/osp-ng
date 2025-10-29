#!/bin/bash

set -eux

HOST=${1:-"${HOST:-""}"}
COMMAND=${@:-"sudo -u stack tmux a"}

if [ -z "${HOST}" ]; then
    echo "\$HOST must be set"
    exit 1
fi

ssh -t root@${HOST} ${COMMAND}
