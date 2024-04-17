#!/bin/bash

# To Record:
# tmux kill-session -t demo; tmux new-session -d -s demo; tmux split-window -t demo:0.0 -v -l15; asciinema rec -c "tmux attach-session -t demo" --overwrite demo.cast
# To minimize:
# asciinema rec -c "asciinema play -i 2 demo.cast" --overwrite demo-minimize.cast

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
TYPE_DELAY=.15
PRE_ENTER_SLEEP=2
POST_ENTER_SLEEP=3
SHOW_SLEEP=3
source ${SCRIPT_DIR}/common.sh

rm -f ~/.viminfo

source ngrc

TMUX_PANE="demo:0.0"
send "export PS1=\"\[\e[91m\]demo@nextgen \[\e[39m\](\w)\n$ \""
enter
send "clear"
enter
TMUX_PANE="demo:0.1"
send "export PS1=\"\[\e[91m\]demo@nextgen \[\e[39m\](\w)\n$ \""
enter
send "clear"
enter

showdeployed() {
    TMUX_PANE="demo:0.0"
    tmux select-pane -t demo:0.0
	types "oc get openstackcontrolplane"
	types "oc get openstackdataplanenodeset"
    typses "oc -n openstack-operators get csv openstack-operator.v0.0.1  -o yaml | less"
    types /.*OPENSTACK_RELEASE_VERSION
    types /.*OVN_CONTROLLER_IMAGE.*
    typn q
    typses "oc get secret dataplanenodeset-openstack-edpm-ipam -o yaml | yq .data.inventory | base64 -d | less"
    types /edpm_ovn_controller_agent_image.*
    typn q
    typses "oc get openstackdataplanedeployment edpm-deployment-ipam -o yaml | less"
    types /deployedVersion.*
    types ?.*containerImages.*
    types /OvnController.*
    typn q
    typses "oc get openstackdataplanenodeset openstack-edpm-ipam -o yaml | less"
    types /deployedVersion.*
    types ?.*containerImages.*
    types /OvnController.*
    typn q
}

showedpmcompute() {
    TMUX_PANE="demo:0.1"
    tmux select-pane -t demo:0.1
    types "ssh -t stack@host06.beaker.tripleo.ral3.eng.rdu2.redhat.com ssh -i openstack-k8s-operators/install_yamls/out/edpm/ansibleee-ssh-key-id_rsa root@192.168.122.100"
    sleep ${SHOW_SLEEP}
    typse "watch -n 6 'podman ps | grep ovn_controller'"
}

editcsv() {
    TMUX_PANE="demo:0.0"
    tmux select-pane -t demo:0.0
    typses "oc -n openstack-operators edit csv openstack-operator.v0.0.1"
    types /18.0.0
    typn Da18.0.1
    sleep 2
    send Escape
    types /OVN_CONTROLLER_IMAGE
    sleep 2
    typn jBDaquay.io/jslagle/openstack-ovn-controller:18.0.1
    sleep 2
    send Escape
    types :wq
    typent "oc -n openstack-operators get pods --selector openstack.org/operator-name=openstack -w"
    sleep 30
    send "C-c"
}

editversion() {
    TMUX_PANE="demo:0.0"
    tmux select-pane -t demo:0.0
    sleep 20
    typses "oc edit openstackversion openstack-galera-network-isolation"
    types /availableVersion
    types /targetVersion
    typn WDa18.0.1
    sleep 2
    send Escape
    sleep 2
    types :wq
    typse "oc wait openstackversion openstack-galera-network-isolation --for condition=MinorUpdateOVNControlplane=True"
    # need to actually wait here
    oc wait openstackversion openstack-galera-network-isolation --for condition=MinorUpdateOVNControlplane=True
    sleep 2
}

showafteredit() {
    TMUX_PANE="demo:0.0"
    tmux select-pane -t demo:0.0
    typses "oc get openstackcontrolplane openstack-galera-network-isolation -o yaml | less"
	types /.*containerImages.*
	types /.*ovnControllerImage.*
	sleep 2
    typn q
    typses "oc get pods --selector service=ovn-controller -o yaml | less"
	types /.*image:.*
    typn q
    typses "oc get secret dataplanenodeset-openstack-edpm-ipam -o yaml | yq .data.inventory | base64 -d | less"
	types /.*edpm_ovn_controller.*
    typn q
    typses "oc get openstackdataplaneservice ovn-update -o yaml | less"
	types /.*play:.*
    typn q
}

deployment() {
    TMUX_PANE="demo:0.0"
    tmux select-pane -t demo:0.0
	typses "cat ~/code/osp-ng/osp-ng/demos/edpm-minor-update/deployments/ovn-update.yml"
	typses "oc apply -f ~/code/osp-ng/osp-ng/demos/edpm-minor-update/deployments/ovn-update.yml"
	typse "oc get openstackansibleee -w"
	# Might need to increase this or figure out a way to wait for the deployment to finish
	sleep 40
    send "C-c"
}

showdeployment() {
    TMUX_PANE="demo:0.0"
    tmux select-pane -t demo:0.0
	typses "oc logs job/ovn-update-ovn-update-openstack-edpm-ipam -f"
	typses "oc get openstackdataplanedeployment ovn-update -o yaml | less"
    types /.*deployedVersion.*
    types ?.*OvnController.*
    typn q
	typses "oc get openstackdataplanenodeset openstack-edpm-ipam -o yaml | less"
    types /.*deployedVersion.*
    types ?.*OvnController.*
    typn q
}

showdeployed
showedpmcompute
editcsv
editversion
showafteredit
deployment
showdeployment

TMUX_PANE="demo:0.1"
tmux select-pane -t demo:0.0
send "C-c"
sleep 0.5
send "C-d"
sleep 0.5
typent "exit"
sleep 0.5
TMUX_PANE="demo:0.0"
typent "exit"
