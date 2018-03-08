#!/bin/sh

/app/create-agent-conf.sh
cat /etc/sigsci/agent.conf
/usr/sbin/sigsci-agent