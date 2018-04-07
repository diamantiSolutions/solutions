#!/bin/bash

. $(dirname ${BASH_SOURCE})/util.sh

run "dctl volume list"
run "dctl volume create pg-vol-0 -s 20G -m 3 "
run "dctl volume create pg-vol-1 -s 20G -m 3 "
run "dctl volume create pg-vol-2 -s 20G -m 3 "
run "dctl volume list"
