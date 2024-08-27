#!/bin/bash

set -eux

cat > dataplane-node-set.yaml << EOF
apiVersion: v1
data:
  network_config_template: |
    ---
    {% set mtu_list = [ctlplane_mtu] %}
    {% for network in nodeset_networks %}
    {{ mtu_list.append(lookup('vars', networks_lower[network] ~ '_mtu')) }}
    {%- endfor %}
    {% set min_viable_mtu = mtu_list | max %}
    network_config:
    - type: ovs_bridge
      name: {{ neutron_physical_bridge_name }}
      mtu: {{ min_viable_mtu }}
      use_dhcp: false
      dns_servers: {{ ctlplane_dns_nameservers }}
      domain: {{ dns_search_domains }}
      addresses:
      - ip_netmask: {{ ctlplane_ip }}/{{ ctlplane_cidr }}
      routes: {{ ctlplane_host_routes }}
      members:
      - type: interface
        name: nic1
        mtu: {{ min_viable_mtu }}
        # force the MAC address of the bridge to this interface
        primary: true
    {% for network in nodeset_networks %}
      - type: vlan
        mtu: {{ lookup('vars', networks_lower[network] ~ '_mtu') }}
        vlan_id: {{ lookup('vars', networks_lower[network] ~ '_vlan_id') }}
        addresses:
        - ip_netmask:
            {{ lookup('vars', networks_lower[network] ~ '_ip') }}/{{ lookup('vars', networks_lower[network] ~ '_cidr') }}
        routes: {{ lookup('vars', networks_lower[network] ~ '_host_routes') }}
    {% endfor %}
kind: ConfigMap
metadata:
  name: network-config-template-ipam
  namespace: openstack
---
apiVersion: v1
data:
  physical_bridge_name: br-ex
  public_interface_name: eth0
kind: ConfigMap
metadata:
  name: neutron-edpm-ipam
  namespace: openstack
---
apiVersion: dataplane.openstack.org/v1beta1
kind: OpenStackDataPlaneNodeSet
metadata:
  name: nodeset
  namespace: openstack
spec:
  env:
  - name: ANSIBLE_FORCE_COLOR
    value: "True"
  networkAttachments:
  - ctlplane
  nodeTemplate:
    ansibleSSHPrivateKeySecret: dataplane-secret
    ansible:
      ansibleVars:
        edpm_bootstrap_command: |
          sudo dnf install -y http://download.lab.bos.redhat.com/rcm-guest/puddles/OpenStack/rhos-release/rhos-release-latest.noarch.rpm
          sudo rhos-release 18.0
          cat > /etc/containers/registries.conf.d/990-registry-proxy.engineering.redhat.com.conf << EOF
          [[registry]]
          location = "registry-proxy.engineering.redhat.com"
          insecure = true
          EOF
        edpm_nodes_validation_validate_controllers_icmp: false
        edpm_nodes_validation_validate_gateway_icmp: false
        edpm_sshd_allowed_ranges:
        - 192.168.122.0/24
        enable_debug: false
        gather_facts: false
      ansibleVarsFrom:
      - configMapRef:
          name: network-config-template-ipam
        prefix: edpm_
      - configMapRef:
          name: neutron-edpm-ipam
        prefix: neutron_
  nodes:
    edpm-compute-0:
      ansible:
        ansibleHost: 192.168.122.100
      hostName: edpm-compute-0
      networks:
      - defaultRoute: true
        fixedIP: 192.168.122.100
        name: ctlplane
        subnetName: subnet1
      - name: internalapi
        subnetName: subnet1
      - name: storage
        subnetName: subnet1
      - name: tenant
        subnetName: subnet1
  preProvisioned: true
EOF

oc apply -f dataplane-node-set.yaml
