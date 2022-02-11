#!/bin/bash
IS_JDK_STATUS=0
IS_TOMCAT_INSTALL=0
function  checkJdk() {
   JDK=$(dpkg -s openjdk-11-jdk)
   if [[ $JDK == *"install ok installed"* ]]; then
        IS_JDK_STATUS=1
   fi
  return 0
}

#function for installing jdk
function installJdk() {
  sudo apt install -y openjdk-11-jdk
  local IS_JDK_INSTALL=$?
  return $IS_JDK_INSTALL
}

#function for check and install tomcat:
function checkTomcat() {
        if [ -d $HOME/middleware/apache-tomcat-10.0.14 ];then
                IS_TOMCAT_INSTALL=1
        fi
}
                

function installTomcat() { 

                mkdir -p $HOME/middleware
                cd $HOME/middleware/
                wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.14/bin/apache-tomcat-10.0.14.tar.gz
                gunzip apache-tomcat-10.0.14.tar.gz
                tar -xvf apache-tomcat-10.0.14.tar
                 rm -rf apache-tomcat-10.0.14.tar
                 IS_TOMCAT_STATUS=$?
                 return $IS_TOMCAT_STATUS
}

#main block
sudo apt update -y
checkJdk
if [ $IS_JDK_STATUS -eq 0 ]; then
        echo  "INFO: jdk is not installed...installing jdk"
        installJdk
        JDK_INSTALL=$?
        if [ $JDK_INSTALL -eq 0 ];then
                echo  "INFO: jdk successfully install.."
        else
                echo  "ERROR: something went wrong while installing jdk ..check logs.."
                        exit  100
        fi
else
        echo "INFO: jdk is already installed so skipping installation.."
fi

checkTomcat
 if [ $IS_TOMCAT_INSTALL -eq 1 ];then
        echo "INFO: Tomcat is available..."
else
        echo "INFO: Tomcat not found ...installing tomcat"
        installTomcat
        if [ $IS_TOMCAT_STATUS -eq 0 ]; then 
                echo "INFO: Tomcat is installed successfully..."
        else    
                echo "ERROR: something went wrong while instatlling tomcat...."
                exit 101
        fi 
 fi