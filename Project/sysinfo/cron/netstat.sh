#!/bin/bash
netstat -ant | to_html | grep -c ESTABLISHED > /tmp/netstat/$2
netstat -ant | to_html | grep -c SYN_SENT >> /tmp/netstat/$2
netstat -ant | to_html | grep -c SYN_RECV >> /tmp/netstat/$2
netstat -ant | to_html | grep -c FIN_WAIT1 >> /tmp/netstat/$2
netstat -ant | to_html | grep -c FIN_WAIT2 >> /tmp/netstat/$2
netstat -ant | to_html | grep -c TIME_WAIT >> /tmp/netstat/$2
netstat -ant | to_html | grep -c CLOSE >> /tmp/netstat/$2
netstat -ant | to_html | grep -c CLOSE_WAIT >> /tmp/netstat/$2
netstat -ant | to_html | grep -c LAST_ASK >> /tmp/netstat/$2
netstat -ant | to_html | grep -c LISTEN >> /tmp/netstat/$2
netstat -ant | to_html | grep -c CLOSING >> /tmp/netstat/$2
netstat -ant | to_html | grep -c UNKNOWN >> /tmp/netstat/$2
let "n = 60 / $1"
sleep $n
