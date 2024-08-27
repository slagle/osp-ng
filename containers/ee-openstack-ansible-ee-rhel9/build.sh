#!/bin/bash

set -eux

podman build -t quay.io/jslagle/ee-openstack-ansible-ee-rhel9:latest .
podman push quay.io/jslagle/ee-openstack-ansible-ee-rhel9:latest
