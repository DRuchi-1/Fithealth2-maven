#!/bin/bash
source /tmp/mysql-secure-installation.sh
IS_MYSQL_INSTALLED=100
function checkMysqlInstallation() {
        VAR=$(dpkg -s mysql-server-8.0 | grep Status)

        if [[ $VAR == *"install ok installed"* ]];then
                IS_MYSQL_INSTALLED=200
        fi
        return 0
}

function installMysql() {
        #whether debconf-utils is installed or not:
        DEB=$( dpkg -s debconf-utils )
        if [[ $DEB == *"install ok installed"* ]];then
                echo "INFO: debconfi-utils is installed !"
        else
                echo "INFO: debconf-utils not found..installing ..."
                sudo apt install -y debconf-utils
        fi

        #avoiding installation using anonymous user = using root user = securely installing
        echo "mysql-server-8.0 mysql-server/root_password password root" | sudo debconf-set-selections
        echo "mysql-server-8.0 mysql-server/root_password_again password root" | sudo debconf-set-selections
        export DEBAIN_FRONTEND="noninteractive"
        sudo apt install -y mysql-server-8.0
        INSTALL_MYSQL_STATUS=$?
        return $INSTALL_MYSQL_STATUS
}

function installExpect() {
        EXP=$(dpkg -s expect)
        if [[ $EXP == *"install ok installed"* ]];then
                echo "INFO: expect utility already installed ..."
        else 
                echo "INFO: expect not found, installing....."
                sudo apt install -y expect 
        fi
}

#main block
sudo apt update -y
checkMysqlInstallation
if [ $IS_MYSQL_INSTALLED -eq 200 ];then
        echo "INFO: mysql-server-8.0 is installed..skipping installation"
else
        echo "INFO: mysql-server-8.0 not installed..installing mysql.."
        installMysql
        if [ $INSTALL_MYSQL_STATUS -eq 0 ]; then
                echo "INFO: mysql-server-8.0 is successfully installed..."
        else
                echo "ERROR: error while installing mysql so check logs.."
                exit 100
        fi
        if [ $INSTALL_MYSQL_STATUS -eq 0 ];then
                echo "INFO: proceeding for mysql secure installation...."
                installExpect 
                mysqlSecureInstallation 

        else
                echo "ERROR: mysql server fail to install ...check for the logs"
        fi
fi


