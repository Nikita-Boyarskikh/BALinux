#!/bin/bash
let "n = 60 / $1"
sudo tcpdump -W 1 -G $n -w /tmp/sysinfo/tcpdump/file$2 -Z root
sudo tcpdump -nevv -r /tmp/sysinfo/tcpdump/file$2 | \
perl -e '
    /length\s(?<length>\d+):.+proto\s(?<proto>\w+).+\n\D+(?<local>\d+\.\d+\.\d+\.\d+\.\d+)\D+(?<foreign>\d+\.\d+\.\d+\.\d+\.\d+)/;
    print(join " ", values %+);
' > /tmp/sysinfo/tcpdump/file$2.dump
