#!/bin/bash

set -eux

cat > enp6s0-crc.yaml << EOF
apiVersion: nmstate.io/v1
kind: NodeNetworkConfigurationPolicy
metadata:
  labels:
    osp/interface: enp6s0
  name: enp6s0-crc
spec:
  desiredState:
    dns-resolver:
      config:
        search: []
        server:
        - 192.168.122.1
    interfaces:
    - description: internalapi vlan interface
      ipv4:
        address:
        - ip: 172.17.0.5
          prefix-length: 24
        dhcp: false
        enabled: true
      ipv6:
        enabled: false
      name: enp6s0.20
      state: up
      type: vlan
      vlan:
        base-iface: enp6s0
        id: 20
        reorder-headers: true
    - description: storage vlan interface
      ipv4:
        address:
        - ip: 172.18.0.5
          prefix-length: 24
        dhcp: false
        enabled: true
      ipv6:
        enabled: false
      name: enp6s0.21
      state: up
      type: vlan
      vlan:
        base-iface: enp6s0
        id: 21
        reorder-headers: true
    - description: tenant vlan interface
      ipv4:
        address:
        - ip: 172.19.0.5
          prefix-length: 24
        dhcp: false
        enabled: true
      ipv6:
        enabled: false
      name: enp6s0.22
      state: up
      type: vlan
      vlan:
        base-iface: enp6s0
        id: 22
        reorder-headers: true
    - description: storagemgmt vlan interface
      ipv4:
        address:
        - ip: 172.20.0.5
          prefix-length: 24
        dhcp: false
        enabled: true
      ipv6:
        enabled: false
      name: enp6s0.23
      state: up
      type: vlan
      vlan:
        base-iface: enp6s0
        id: 23
        reorder-headers: true
    - description: Octavia vlan host interface
      name: enp6s0.24
      state: up
      type: vlan
      vlan:
        base-iface: enp6s0
        id: 24
    - bridge:
        options:
          stp:
            enabled: false
        port:
        - name: enp6s0.24
      description: Configuring bridge octbr
      mtu: 1500
      name: octbr
      state: up
      type: linux-bridge
    - description: designate vlan interface
      ipv4:
        address:
        - ip: 172.28.0.5
          prefix-length: 24
        dhcp: false
        enabled: true
      ipv6:
        enabled: false
      name: enp6s0.25
      state: up
      type: vlan
      vlan:
        base-iface: enp6s0
        id: 25
        reorder-headers: true
    - bridge:
        options:
          stp:
            enabled: false
        port:
        - name: enp6s0
          vlan: {}
      description: Configuring Bridge ospbr with interface enp6s0
      ipv4:
        address:
        - ip: 192.168.122.10
          prefix-length: 24
        dhcp: false
        enabled: true
      ipv6:
        enabled: false
      mtu: 1500
      name: ospbr
      state: up
      type: linux-bridge
  nodeSelector:
    kubernetes.io/hostname: crc
    node-role.kubernetes.io/worker: ""
EOF

oc apply -f enp6s0-crc.yaml
