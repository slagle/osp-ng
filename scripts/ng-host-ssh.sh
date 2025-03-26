#!/bin/bash

set -eux

HOST=${1:-"${HOST:-"host05.beaker.tripleo.ral3.eng.rdu2.redhat.com"}"}

ssh -t root@${HOST} sudo -u stack tmux a