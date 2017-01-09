#!/bin/bash
let "n = 60 / $1"
sudo tcpdump -W 1 -G $n -w /tmp/sysinfo/tcpdump/file$2 -Z root
sudo tcpdump -nevv -r /tmp/sysinfo/tcpdump/file$2 > /tmp/sysinfo/tcpdump/file$2.dump
