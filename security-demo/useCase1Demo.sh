#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

#Network-admin"
run "echo \"----------------- Users Case-1: Network admin ------------------\""
run "dctl login -u u1 -p Pass1234!"
run "dctl network create blue -s 172.16.157.0/24 --start 172.16.157.4 --end 172.16.157.253 -g 172.16.157.1 -v 157"
run "dctl logout"
run "dctl login -u na -p Pass1234!"
run "dctl network create blue -s 172.16.157.0/24 --start 172.16.157.4 --end 172.16.157.253 -g 172.16.157.1 -v 157"
run "dctl logout"
run "dctl login -u ua -p Pass1234!"
run "dctl user group edit ug0 --role-list container-edit/ns0,network-view"
run "dctl user group edit ug1 --role-list container-edit/ns1,network-view"
run "dctl logout"
