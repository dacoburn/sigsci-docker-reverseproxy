#!/bin/sh

if [ ! -d /etc/sigsci ]; then 
	mkdir /etc/sigsci
fi

echo accesskeyid=$SIGSCI_ACCESSKEYID > /etc/sigsci/agent.conf
echo secretaccesskey=$SIGSCI_SECRETACCESSKEY >> /etc/sigsci/agent.conf
echo [revproxy-listener.sigscikube] >> /etc/sigsci/agent.conf
echo listener = \"http://0.0.0.0:80\" >> /etc/sigsci/agent.conf
echo upstreams = \"$SIGSCI_UPSTREAM\" >> /etc/sigsci/agent.conf