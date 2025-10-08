#!/bin/bash

set -eux

HOST=${1:-"${HOST:-""}"}

if [ -z "${HOST}" ]; then
    echo "\$HOST must be set"
    exit 1
fi

ssh -t root@${HOST} sudo -u stack tmux a
