#!/bin/bash

set -eux

# kubeadmin/kubeadmin
oc create secret generic -n openshift-config htpasswd-secret --from-literal='htpasswd=kubeadmin:$2y$05$/SRWLAwI.75HUWRKd9D95efApXm41lHPWkRKvuBIQW5tJxMTgC9Bu' # notsecret

oc patch oauth cluster     --type json     -p='[{"op": "add", "path": "/spec/identityProviders", "value": []}]'

oc patch oauth cluster     --type json     -p='[{"op": "add", "path": "/spec/identityProviders/-", "value": {"htpasswd": {"fileData": {"name": "htpasswd-secret"}}, "mappingMethod": "claim", "name": "htpasswd_provider", "type": "HTPasswd"}}]'