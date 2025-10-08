#!/bin/bash

set -eux

CRC_HOST=${CRC_HOST:-""}

if [ -z "${CRC_HOST}" ]; then
    echo "\$CRC_HOST must be set"
    exit 1
fi

sshuttle -r root@${CRC_HOST} 192.168.130.0/24
