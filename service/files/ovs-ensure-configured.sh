#!/bin/bash

bridge=$1
port=$2

ovs-vsctl br-exists $bridge; rc=$?
if [[ $rc == 2 ]]; then
    changed=changed
    ovs-vsctl --no-wait add-br $bridge
fi

ovs_veth="veth_${bridge}"
lnx_veth="veth_${port}"

#(FIXME) add proper validation
ip link show ${ovs_veth}; rc=$?
if [[ $rc == 1 ]]; then
    changed=changed
    ip link add ${ovs_veth} type veth peer name ${lnx_veth}
    ip link set up ${ovs_veth}
    ip link set up ${lnx_veth}
    brctl addif ${port} ${lnx_veth}
fi

if [[ ! $(ovs-vsctl list-ports $bridge) =~ $(echo "\<$port\>") ]]; then
    changed=changed
    ovs-vsctl --no-wait add-port $bridge ${ovs_veth}
fi

echo $changed
