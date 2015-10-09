#!/bin/sh
mkdir -p /var/log/rexster
DOCKERHOST=`hostname`
DOCKERIP=`grep $DOCKERHOST /etc/hosts|awk '{print $1}'`
sed 's/{{DOCKERIP}}/'"$DOCKERIP"'/g' /rexster-server/config/rexster-neo4j2.tpl.xml > /rexster-server/config/rexster-neo4j2.xml
cd /rexster-server
exec /rexster-server/bin/rexster.sh -s -c /rexster-server/config/rexster-neo4j2.xml >> /var/log/rexster/rexster.log 2>&1
