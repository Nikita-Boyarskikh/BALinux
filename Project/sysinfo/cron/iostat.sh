#!/bin/bash
let "n = $(cat /proc/cpuinfo | grep -c 'core id') + 3"
iostat -xpd | tail -n+4 | head -n-1 > /tmp/sysinfo/iostat/$2
iostat -d | tail -n+4 | head -n-1 > /tmp/sysinfo/iostat/$2_1
let "n = 60 / $1"
sleep $n
