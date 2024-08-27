#!/bin/bash

set -eux

cat > osp-secret.yaml << EOF
apiVersion: v1
data:
  AdminPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  AodhPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  AodhDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  BarbicanDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  BarbicanPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  BarbicanSimpleCryptoKEK: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  CeilometerPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  CinderDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  CinderPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  DatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  DbRootPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  DesignateDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  DesignatePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  GlanceDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  GlancePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  HeatAuthEncryptionKey: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  HeatDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  HeatPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  IronicDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  IronicInspectorDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  IronicInspectorPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  IronicPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  KeystoneDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  ManilaDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  ManilaPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  MetadataSecret: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NeutronDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NeutronPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NovaAPIDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NovaAPIMessageBusPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NovaCell0DatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NovaCell0MessageBusPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NovaCell1DatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NovaCell1MessageBusPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  NovaPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  OctaviaDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  OctaviaPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  PlacementDatabasePassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  PlacementPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
  SwiftPassword: $(tr -dc 'A-Za-z0-9!@#$%^$(openssl rand -base64 32)*()' < /dev/urandom | head -c 32 | base64)
kind: Secret
metadata:
  name: osp-secret
  namespace: openstack
type: Opaque
EOF

oc apply -f osp-secret.yaml
