#!/bin/bash

set -eux

SECRET_NAME=dataplane-secret
KEY_FILE_NAME=ansibleee-ssh-key-id_rsa

oc create secret generic $SECRET_NAME \
--save-config \
--dry-run=client \
--from-file=ssh-privatekey=$KEY_FILE_NAME \
--from-file=ssh-publickey=$KEY_FILE_NAME.pub \
-n openstack \
-o yaml | oc apply -f-

ssh-keygen -f ./id -t ecdsa-sha2-nistp521 -N ''

oc create secret generic nova-migration-ssh-key \
--from-file=ssh-privatekey=id \
--from-file=ssh-publickey=id.pub \
-n openstack \
-o yaml | oc apply -f-

oc describe secret $SECRET_NAME
oc describe secret nova-migration-ssh-key
