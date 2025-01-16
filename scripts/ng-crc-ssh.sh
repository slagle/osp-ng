#!/bin/bash

ARGS="$@"
if [ -z "$ARGS" ]; then
    ARGS="/bin/bash"
fi

ssh -t -i $HOME/.crc/machines/crc/id_ed25519 core@192.168.130.11 sudo -i "${ARGS}"
