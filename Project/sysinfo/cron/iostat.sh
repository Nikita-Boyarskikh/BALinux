#!/bin/bash
let "n = $(cat /proc/cpuinfo | grep -c 'core id') + 3"
iostat -xpd | tail -n+4 | head -n-1 > /tmp/sysinfo/iostat/$2
iostat -dp | tail -n+4 | head -n-1 > /tmp/sysinfo/iostat/$2-1
let "n = 60 / $1"
sleep $n
