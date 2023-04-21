#!/bin/bash

# To Record:
# tmux kill-session -t demo; tmux new-session -d -s demo; asciinema rec -c "tmux attach-session -t demo" --overwrite demo.cast
# To minimize:
# asciinema rec -c "asciinema play -i 2 demo.cast" --overwrite demo-minimize.cast

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source ${SCRIPT_DIR}/common.sh

sshclean() {
    ssh -t -i ansibleee-ssh-key-id_rsa root@192.168.122.100 << EOF
systemctl stop edpm_*
podman ps -aq  | xargs -t podman rm
EOF
}

rm -f ~/.viminfo

export PATH="/home/jslagle/.crc/bin/oc:$PATH"

TMUX_PANE="demo:0.0"
send "export PS1=\"\[\e[91m\]demo@nextgen \[\e[39m\](\w)\n$ \""
enter
send "export PATH=\"/home/jslagle/.crc/bin/oc:$PATH\""
enter
send "clear"
enter
oc login -u kubeadmin -p 12345678 https://api.crc.testing:6443

delete() {
    oc delete --ignore-not-found openstackdataplane openstack-edpm
}

vidataplane() {
    TMUX_PANE="demo:0.0"
    typ "# Dataplane and Nova CRDs for EDPM."
    typ "oc get crd novaexternalcomputes.nova.openstack.org"
    typ "oc get crd | grep dataplane"
    typn vi dataplane.yaml
    sleep 1
    enter
    typ /deployStrategy
    typ /roles
    typ /networkAttachment
    typ /nodeTemplate
    typ /ansibleVars
    typ /nodes:
    typ /role
    typ G
    typ :q
}

create() {
    TMUX_PANE="demo:0.0"
    typ "# Create the Dataplane CR."
    typ oc create -f dataplane.yaml
    typ "# Check created resources."
    typ oc get openstackdataplane
    typ oc get openstackdataplanerole
    typ oc get openstackdataplanenode
}

watch() {
    TMUX_PANE="demo:0.0"
    TYPE_DELAY=0.03 typ oc get openstackdataplanerole -w
    enter
    TMUX_PANE="demo:0.1"
    TYPE_DELAY=0.03 typ oc get openstackansibleee -o custom-columns=NAME:.metadata.name,STATUS:.status.JobStatus,CREATED:.metadata.creationTimestamp -w
    enter
}

deploy() {
    TMUX_PANE="demo:0.0"
    typ "# Edit the Dataplane CR in the API and toggle the deploy flag."
    typ oc edit openstackdataplane openstack-edpm
    typ :1
    enter
    typ /deploy:
    typn wwcwtrue
    send Escape
    typ :wq
    sleep 2
}

unwatch() {
    TMUX_PANE="demo:0.0"
    send "C-c"
    enter
    TMUX_PANE="demo:0.1"
    send "C-c"
    enter
}

logs() {
    TMUX_PANE="demo:0.0"
    typ "# Check completed OpenStackAnsibleEE and NovaExternalCompute resources."
    typ oc get openstackansibleee
    typ oc get novaexternalcompute
    logpod=$(oc get pods | grep dataplane-deployment-configure-network | awk '{print $1}')
    typ "# Show Ansible logs from the configure-network pod."
    typ "oc get pods | grep dataplane-deployment"
    typ oc logs ${logpod}
}


sshnode() {
    TMUX_PANE="demo:0.0"
    typ "# SSH to the edpm-compute-0 node and check that podman containers are started."
    typ ssh -i ansibleee-ssh-key-id_rsa root@192.168.122.100
    sleep 5
    typ podman ps
    typ exit
}

TMUX_PANE="demo:0.0"
delete
typ "# WELCOME TO THE 2023 Q1 EDPM DEMO."
vidataplane
create
deploy

typ "# Split the window so we can watch in progress DataplaneRole and OpenStackAnsibleEE resources."
tmux split-window -t demo:0.0 -v
TMUX_PANE="demo:0.1"
send "export PATH=\"/home/jslagle/.crc/bin/oc:$PATH\""
enter
send "export PS1=\"\[\e[91m\]demo@nextgen \[\e[39m\](\w)\n$ \""
enter
send "clear"
enter
tmux select-pane -t demo:0.0

watch
oc wait --timeout -1s --for=condition=Ready openstackdataplane openstack-edpm
unwatch

TMUX_PANE="demo:0.1"
send "exit"
enter

TMUX_PANE="demo:0.0"
logs
sshnode
typ "# THE END."
