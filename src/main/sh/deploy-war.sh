#!/bin/bash
function deployWar() { 
sudo systemctl stop tomcat
 rm -rf $HOME/middleware/apache-tomcat-10.0.14/webapps/fithealth*
 cp /tmp/fithealth2.war $HOME/middleware/apache-tomcat-10.0.14/webapps/
 sudo systemctl restart tomcat
 local IS_WAR_DEPLOYED=$?
 return $IS_WAR_DEPLOYED
}

#MAIN BLOCK
deployWar
IS_WAR_DEP=$?
if [ $IS_WAR_DEP -eq 0 ]; then 
    echo "INFO: war file deployed successfully..."
else 
    echo "ERROR: something went wrong while deploying war file..check catalina.out"
    exit 103
fi