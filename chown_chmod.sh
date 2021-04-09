#!/bin/bash
#script to change ownership and permissions


chown -Rv webadmin:webadmin $1
chmod -Rv 775 $1
exit 0
