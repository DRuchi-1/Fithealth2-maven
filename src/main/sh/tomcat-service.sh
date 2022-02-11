#!/bin/bash
IS_TOMCAT_SERVICE=0

function checkTomcatService() {
    SERVICE=$(sudo systemctl status tomcat)
    if [[ $SERVICE == *"Unit tomcat.service could not be found."* ]]; then 
        IS_TOMCAT_SERVICE=1     
    fi
    return 0 
}

function configureTomactAsService() {
sed -i 's|#HOME|'$HOME'|g' /tmp/tomcat.service.conf
sudo cp /tmp/tomcat.service.conf /etc/systemd/system/tomcat.service
sudo systemctl daemon-reload
sudo systemctl restart tomcat
echo "INFO: Tomcat is configured as service successfully..."
}
  

#main block:
checkTomcatService
if [ $IS_TOMCAT_SERVICE -eq 0 ]; then
    echo "INFO: tomcat.service file found ..deleting .."
    #rm -rf /etc/systemd/system/tomcat.service
else    
    echo "INFO: tomcat.service file not found..creating.."
fi
configureTomactAsService