#!/bin/bash

set -eux

cat > openstacknetconfig.yaml << EOF
apiVersion: network.openstack.org/v1beta1
kind: NetConfig
metadata:
  name: openstacknetconfig
  namespace: openstack
spec:
  networks:
  - name: CtlPlane
    dnsDomain: ctlplane.example.com
    subnets:
    - name: subnet1
      allocationRanges:
      - end: 192.168.122.120
        start: 192.168.122.100
      - end: 192.168.122.200
        start: 192.168.122.150
      cidr: 192.168.122.0/24
      gateway: 192.168.122.1
  - name: InternalApi
    dnsDomain: internalapi.example.com
    subnets:
    - name: subnet1
      allocationRanges:
      - end: 172.17.0.250
        start: 172.17.0.100
      excludeAddresses:
      - 172.17.0.10
      - 172.17.0.12
      cidr: 172.17.0.0/24
      vlan: 20
  - name: External
    dnsDomain: external.example.com
    subnets:
    - name: subnet1
      allocationRanges:
      - end: 10.0.0.250
        start: 10.0.0.100
      cidr: 10.0.0.0/24
      gateway: 10.0.0.1
  - name: Storage
    dnsDomain: storage.example.com
    subnets:
    - name: subnet1
      allocationRanges:
      - end: 172.18.0.250
        start: 172.18.0.100
      cidr: 172.18.0.0/24
      vlan: 21
  - name: StorageMgmt
    dnsDomain: storagemgmt.example.com
    subnets:
    - name: subnet1
      allocationRanges:
      - end: 172.20.0.250
        start: 172.20.0.100
      cidr: 172.20.0.0/24
      vlan: 23
  - name: Tenant
    dnsDomain: tenant.example.com
    subnets:
    - name: subnet1
      allocationRanges:
      - end: 172.19.0.250
        start: 172.19.0.100
      cidr: 172.19.0.0/24
      vlan: 22
EOF

oc apply -f openstacknetconfig.yaml
