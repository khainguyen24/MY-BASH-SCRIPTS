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



====================
# bypass the wait time and check the deployment folder now.
#prompt Y N
PROMPT_RECHECK_WARS () {
    	echo -e "\e[33mIf jboss is finished restarting...\e[0m"
	sleep 1
while true; do
    read -p "Do you want to recheck the deployments folder now? Enter y or n  " yn
    case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
     * ) echo "Please answer yes or no.";;
    esac
done


===============================
# experimental using an optional argument
