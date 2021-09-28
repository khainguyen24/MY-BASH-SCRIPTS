#!/bin/bash
# script restart jboss and grab date, failed wars
# Note: just create this directory first  mkdir /var/temp/jboss_restart_failed_wars

# support function

function RESTART_JBOSS() {
  # log the date to /var/temp/jboss_resart.logs
  echo -n "Start Time: " >> /var/temp/jboss_restart_log.txt
  date >> /var/temp/jboss_restart_log.txt
  #restarting jboss
  /etc/init.d/jboss restart
  sleep 240
  FAILED_WARS_COUNT="$(find /opt/jboss/default/standalone/deployments -type f -name '*.failed' | wc -l)"
  echo -e "List Failed wars after restart if any: ${FAILED_WARS_COUNT}" >> /var/temp/jboss_restart_log.txt
  #find list all failed wars
  find /opt/jboss/default/standalone/deployments -type f -name '*.failed' >> /var/temp/jboss_restart_log.txt
  #move the failed wars to the /var/temp/jboss_restart_log_failed_wars/
  find /opt/jboss/default/standalone/deployments -type f -name '*.failed' -exec mv {} /var/temp/jboss_restart_failed_wars \;
  echo -n "End Time: " >> /var/temp/jboss_restart_log.txt
  date >> /var/temp/jboss_restart_log.txt
  echo -e "\n"
}

# RUN STUFF
RESTART_JBOSS




--------------------------------------------------------

touch test_1.failed test_3.failed test_2.failed test_4.failed test_5.failed test_6.failed

touch test_7.failed test_8.failed test_8.failed

touch test_9.failed
