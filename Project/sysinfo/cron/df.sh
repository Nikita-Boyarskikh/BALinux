#!/bin/bash
df --output | tail -n+2 | awk '$1 !~ /^\/(dev|sys|proc)/'> /tmp/sysinfo/df/$2
let "n = 60 / $1"
sleep $n
