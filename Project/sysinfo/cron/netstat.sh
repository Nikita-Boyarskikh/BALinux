#!/bin/bash
netstat -ant | grep -c ESTABLISHED > /tmp/sysinfo/netstat/$2
netstat -ant | grep -c SYN_SENT >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c SYN_RECV >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c FIN_WAIT1 >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c FIN_WAIT2 >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c TIME_WAIT >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c CLOSE >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c CLOSE_WAIT >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c LAST_ASK >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c LISTEN >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c CLOSING >> /tmp/sysinfo/netstat/$2
netstat -ant | grep -c UNKNOWN >> /tmp/sysinfo/netstat/$2
let "n = 60 / $1"
sleep $n
