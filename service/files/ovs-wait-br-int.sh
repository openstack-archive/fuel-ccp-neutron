#!/bin/bash -ex

br_create_wait_timeout=600
retry_check_interval=5

testcmd="sudo ovs-vsctl list Bridge | grep br-int"

if ! timeout $br_create_wait_timeout sh -c "while ! $testcmd; do sleep $retry_check_interval; done"; then
        exit $?
fi
