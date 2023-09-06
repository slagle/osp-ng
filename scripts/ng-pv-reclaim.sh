#!/bin/bash

set -eux

for pv in $(oc get pv | grep Released | cut -d' ' -f1)
do
    oc patch pv $pv -p '{"spec":{"claimRef": null}}'
done
