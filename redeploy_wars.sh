#!/bin/bash
#redeploy failed wars script

#Change Log
# 05/16/19 - Updated MAIN_CHECK_2 at after redeploying wars if it still had failed war the script was still echo -e "\e[35mAwesome! It's Looking good now." removed this and added the MAIN_CHECK_2.
# 10/22/19 - Removed all the fluff and renamed it to redeploy_wars.sh
# Start health Check message
echo -e "\e[92mStarting Health Check..."
sleep 2

# Check Jboss is running
echo -e "\e[92mChecking jboss status..\e[0m";
sleep 2
service jboss status
sleep 2

# list deployed and failed
LIST1 () {
        echo -e "\e[32mChecking all deployments..."
        sleep 2
        printf "\e[0m"
        cd /opt/jboss/default/standalone/
        find deployments -name '*.deployed'
        printf "\n\e[31m"
        sleep 2
        find deployments -name '*.failed'
        printf "\n\e[0m"

}

# Results Displayed find function ***Need to update with correct path*****
LIST2 () {

	VAR_X=$(find /opt/jboss/default/standalone/deployments -name '*.xml' | wc -l)
	VAR_R=$(find /opt/jboss/default/standalone/deployments -name '*.rar' | wc -l)
	VAR_W=$(find /opt/jboss/default/standalone/deployments -name '*.war' | wc -l)
        VAR_D=$(find /opt/jboss/default/standalone/deployments -name '*.deployed' | wc -l)
        VAR_F=$(find /opt/jboss/default/standalone/deployments -name '*.failed' | wc -l)
        VAR_T=$(( $VAR_W + $VAR_X + $VAR_R ))
        echo -e "\e[35mResults: \e[0mOut of $VAR_T=($VAR_W .war $VAR_X .xml and $VAR_R .rar) files: $VAR_D=\e[32mdeployed \e[0mand $VAR_F=\e[31mfailed"
	printf "\n\e[0m"
}

# JBOSS VAR
STOP_JBOSS () {
service jboss stop
}

START_JBOSS () {
service jboss start
}

STATUS_JBOSS () {
service jboss status
}
# remove temp folders change rm -vrf to ls for testing
REMOVE_TEMP () {
cd /opt/jboss/default/standalone/
rm -rf tmp/ data/
}

#Removing the .failed and .deployed
REMOVE_FAILED_DEPLOYED () {
cd /opt/jboss/default/standalone/deployments
rm -f *.failed
rm -f *.deployed
}

# DELETE failed war and Redeploy function
#prompt Y N
MAIN_1 () {
    	echo -e "\e[33mOops! No Bueno.. \e[0mLooks like we've got $VAR_F deployment that \e[31mfailed.\e[0m"
	sleep 1
	echo -e "\n\e[35m¯\_(ツ)_/¯ ***DELETE & REDEPLOY*** ¯\_(ツ)_/¯\e[0m"
	sleep 1
while true; do
    read -p "Do you want to delete the failed deployments and Redeploy? Enter y or n  " yn
    case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
     * ) echo "Please answer yes or no.";;
    esac
done
printf "\e[0m"
REDEPLOY_WAR
}

REDEPLOY_WAR () {
        echo -e "\e[32mStoping jboss..\e[0m"
        sleep 2
        STOP_JBOSS
        echo -e "\e[32mRemoving temp & data..\e[0m"
        sleep 3
        REMOVE_TEMP
        echo -e "\e[32mRemoving failed and deployed wars..\e[0m"
        sleep 2
        REMOVE_FAILED_DEPLOYED
        sleep 2
        echo -e "\e[35m\nComplete!\e[0m"
        sleep 2
        echo -e "\e[32mStarting jboss and Redeploying wars...\e[0m"
        sleep 2
        START_JBOSS
        sleep 190
        printf "\e[0m"
	LIST1
        sleep 2
	LIST2
	      sleep 2
	MAIN_CHECK_2
	      printf "\e[0m"

}
#Status check
MAIN_CHECK () {
	NUM1="$VAR_F";
	NUM2=0;
	NUM3="$VAR_D";
	if [ "$NUM1" ==  "$NUM2" ] && [ "$NUM3" != "$NUM2" ]; then
	echo -e "\e[35mAwesome! It's Looking Good.\e[0m"
	else
	MAIN_1
	fi
}
#Second status ckeck after failed war removal
MAIN_CHECK_2 () {
	NUM1="$VAR_F";
	NUM2=0;
	NUM3="$VAR_D";
	if [ "$NUM1" ==  "$NUM2" ] && [ "$NUM3" != "$NUM2" ]; then
	echo -e "\e[35mAwesome! It's Looking Good Now.\e[0m"
	else
	echo -e "\e[35mYikes! Not looking good.. time to call Dan.\e[0m"
	fi
}

# Do stuff
LIST1
sleep 2
LIST2
sleep 3
MAIN_CHECK
