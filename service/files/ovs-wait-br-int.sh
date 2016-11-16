#!/bin/bash -ex

br_create_wait_timeout=60
retry_check_interval=5

testcmd="sudo ovs-vsctl list Bridge | grep br-int"

timeout $br_create_wait_timeout sh -c "while ! $testcmd; do sleep $retry_check_interval; done"
exit $?
