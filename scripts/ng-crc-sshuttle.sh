#!/bin/bash

set -eux

CRC_HOST=${CRC_HOST:-"host05.beaker.tripleo.ral3.eng.rdu2.redhat.com"}

sshuttle -r root@${CRC_HOST} 192.168.130.0/24
