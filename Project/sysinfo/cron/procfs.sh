#!/bin/bash
cat /proc/net/dev | tail -n+3 > /tmp/sysinfo/mpstat/$2
let "n = 60 / $1"
sleep $n
