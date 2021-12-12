#! /bin/bash
bash /opt/tomcat/bin/catalina.sh run
#touch /opt/tomcat/logs/localhost_access_log.`date +%F`.txt
#sleep 10
#tail -f /opt/tomcat/logs/localhost_access_log.`date +%F`.txt > /dev/stdout;