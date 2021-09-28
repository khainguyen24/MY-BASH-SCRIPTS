#!/bin/bash
# AC2SP Cloud config script to be used in conjunction/after the oracle_user_data3_dan.txt scripts
# Dan updated the oracle_user_data3_dan.txt to include all the necessacary packages for an oracle db 11g install as well as creating the oracle user and groups
# pre-requisits before running this scripts:
  #created and attached a 1TB volume to the instance
  #create file system and mount the volume to /u01
  # - lsblk #get the volume name.. in this case it's nvme3n1
  # - file -s /dev/nvme3n1 #checks the volume for a file system will read 'data'if there is no file systems
  # - mkfs -t xfs /dev/nvme3n1 #creates a xsf file system on the nvme3n1 volume. Use: 'mkfs.xfs -f /dev/nvme3n1' to force overwrite Note: xfs seems to perform better than ext4 for oracle db
  # - mkdir /u01 #create dir to mount the volume (no need.. was created in the oracle_user_data3_dan.txt)
  # - mount /dev/nvme3n1 /u01 #mounts the /dev/nvme3n1 volume to the /u01 directory
  # - file -s /dev/nvme3n1 #checks the volume for a file system should now see that a xsf file system has been created and the volume is mounted on the /u01 dir
  # - df -Th #command list mounted file systems
  # - vim /etc/fstab #add entry for the new volume to be mounted permanatly
  # - /dev/nvme3n1 /u01 xfs defaults 0 0 #add this entry to the /etc/fstab file and save. On startup it should automatically mount now
  # - mount -a #mount all
  # - reboot the server and make sure it startup properly with the new volume mounted
# Note the install will take some time to finish best to run it in screen and nohup the output:
#example:
# screen -S oracle-full-j
# cd /root/
# nohup bash -x ./ac2sp_oracle_11g_install.sh > ac2sp_oracle_11g_install.log &
# to detach from this screen session: ctr+a then press d
# to re-attach screen -ls then screen -r <session_id>oracle-full-j.


function RUN_USER_DATA_CLOUD_INIT () {
  #note: update the " i2ar-test-oracle-full-j" with the correct alias for the instance not to sure if we need a second entry at all
  echo $(curl http://169.254.169.254/latest/meta-data/local-ipv4) $(hostname)" i2ar-test-oracle-full-j" >> /etc/hosts
  #Note: this packages were installed with the oracle_user_data3_dan.txt scripts
  #yum install -y glibc.i686 compat-libstdc++.i686 glibc-devel.i686 libgcc.i686 libstdc++.i686 libstdc++-devel.i686 libaio.i686 libaio-devel.i686 unixODBC.i686 unixODBC-devel.i686
  sed -i 's/PATH=/#PATH=/' /home/oracle/.bash_profile
  sed -i 's/export PATH/#export PATH/' /home/oracle/.bash_profile
  echo umask 022 >> /home/oracle/.bash_profile
  echo ulimit -u 16384 -n 65536 >> /home/oracle/.bash_profile
  echo export ORACLE_BASE=/u01/app/oracle >> /home/oracle/.bash_profile
  echo export TMP=/tmp >> /home/oracle/.bash_profile
  echo export TMPDIR=/tmp >> /home/oracle/.bash_profile
  echo export ORACLE_HOME=\$ORACLE_BASE/product/11.2.0/dbhome_1 >> /home/oracle/.bash_profile
  echo export ORACLE_SID=birv2 >> /home/oracle/.bash_profile
  echo export PATH=\$ORACLE_HOME/bin:\$ORACLE_HOME/OPatch:\$PATH >> /home/oracle/.bash_profile
  echo export LD_LIBRARY_PATH=\$ORACLE_HOME/lib:/usr/lib64 >> /home/oracle/.bash_profile
  echo oracle soft nproc 2047 >> /etc/security/limits.conf
  echo oracle hard nproc 16384 >> /etc/security/limits.conf
  echo oracle soft nofile 1024 >> /etc/security/limits.conf
  echo oracle hard nofile 65536 >> /etc/security/limits.conf
  echo session required pam_limits.so >> /etc/pam.d/login
  echo fs.aio-max-nr=1048576 >> /etc/sysctl.conf
  echo fs.file-max = 6815744 >> /etc/sysctl.conf
  echo kernel.shmmni = 4096 >> /etc/sysctl.conf
  echo kernel.sem = 250 32000 100 128 >> /etc/sysctl.conf
  echo net.ipv4.ip_local_port_range = 9000 65500 >> /etc/sysctl.conf
  echo net.core.rmem_default = 262144 >> /etc/sysctl.conf
  echo net.core.rmem_max = 4194304 >> /etc/sysctl.conf
  echo net.core.wmem_default = 262144 >> /etc/sysctl.conf
  echo net.core.wmem_max = 1048586 >> /etc/sysctl.conf
  echo net.ipv4.tcp_wmem =262144 262144 262144 >> /etc/sysctl.conf
  echo net.ipv4.tcp_wmem =4194304 4194304 4194304 >> /etc/sysctl.conf
  #commenting this out because creating attaching and mounting to /u01 should of been done before running this scripts
  #mkdir /u01
  mkdir /u01/OraResp
  mkdir -p /u01/OraSW/11.2.0.4
  mkdir -p /u01/app/oracle
  chown -R oracle:oinstall /u01/app/oracle
  touch /etc/oraInst.loc
  echo inventory_loc=/u01/app/oracle/oraInventory >> /etc/oraInst.loc
  echo inst_group=oinstall >> /etc/oraInst.loc
  chown -R oracle:oinstall /etc/oraInst.loc
  mkdir /data00
  dd if=/dev/zero of=/var/ora_swap bs=1G count=20
  sleep 25m
  mkswap /var/ora_swap
  swapon /var/ora_swap
  echo /var/ora_swap swap swap defaults 0 0 >> /etc/fstab
  echo none /dev/shm tmpfs defaults,size=18G 0 0 >> /etc/fstab
  mount -a
  aws s3 cp s3://oracle-files-new/swInstallv4.rsp /u01/OraResp/swInstallv4.rsp
  sleep 10
  aws s3 cp s3://oracle-files-new/netInstallv4.rsp /u01/OraResp/netInstallv4.rsp
  sleep 10
  aws s3 cp s3://oracle-files-new/dbInstallv4.rsp /u01/OraResp/dbInstallv4.rsp
  sleep 10
  aws s3 cp s3://oracle-files-new/p13390677_112040_Linux-x86-64_1of7.zip /u01/OraSW/11.2.0.4/p13390677_112040_Linux-x86-64_1of7.zip
  sleep 10
  aws s3 cp s3://oracle-files-new/p13390677_112040_Linux-x86-64_2of7.zip /u01/OraSW/11.2.0.4/p13390677_112040_Linux-x86-64_2of7.zip
  unzip /u01/OraSW/11.2.0.4/p13390677_112040_Linux-x86-64_1of7.zip -d /u01/OraSW/11.2.0.4
  sleep 10
  unzip /u01/OraSW/11.2.0.4/p13390677_112040_Linux-x86-64_2of7.zip -d /u01/OraSW/11.2.0.4
  chown -R oracle:oinstall /u01/
  chmod -R 775 /u01/app/oracle
  runuser -l oracle -c 'sh /u01/OraSW/11.2.0.4/database/runInstaller -silent -noconfig -ignorePrereq -responseFile /u01/OraResp/swInstallv4.rsp'
  sleep 20m
  aws s3 cp s3://oracle-files-new/bir2v4.dbt /u01/app/oracle/product/11.2.0/dbhome_1/assistants/dbca/templates/bir2v4.dbt
  sleep 2m
  sh /u01/app/oracle/product/11.2.0/dbhome_1/root.sh
  sleep 5m
  runuser -l oracle -c 'netca -silent -responseFile /u01/OraResp/netInstallv4.rsp'
  sleep 5m
  runuser -l oracle -c 'dbca -silent -responseFile /u01/OraResp/dbInstallv4.rsp'
  sleep 2m
  mkdir /home/oracle/.dbora
  aws s3 cp s3://oracle-files-new/startup.sh /home/oracle/.dbora/startup.sh
  sleep 10
  aws s3 cp s3://oracle-files-new/shutdown.sh /home/oracle/.dbora/shutdown.sh
  sleep 10
  chown -R oracle:oinstall /home/oracle/.dbora
  chmod -R 750 /home/oracle/.dbora
  aws s3 cp s3://oracle-files-new/dbora /etc/init.d/dbora
  chmod -R 750 /etc/init.d/dbora
  chkconfig --add dbora

}

#run it
echo "running the RUN_USER_DATA_CLOUD_INIT.."
DATE="$(date)"
echo "Start Time: ${DATE}"
RUN_USER_DATA_CLOUD_INIT
echo "End Time: ${DATE}"
echo "..all DONE!"
echo "Check the /u01/app/oracle/oraInventory/logs/ to make sure the install was a success.. "
echo "Note on the GovCloud Oracle DB server the log silentInstall2017-05-16_04-09-12PM.log does show 1 error too. 'Error in invoking target 'agent nmhs' agent nmhs..'"
