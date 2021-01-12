#!/bin/bash
#lets create a copy of the iso to use in the environemt
echo "Please ensure that your CentOS Installation ISO is attached to your VM!"
echo "Creating copy of your ISO, please be patient as this will take a few mintues!"
cp /dev/sr0 /root/centos.iso
#this command will install git on the server
yum install -y git
#this command will give a temporary working directory
OUT="$(mktemp -d /run/tmp.XXX)"
cd $OUT
#this command will clone the LIAB repo to the local machine 
git clone https://github.com/aksoutherland/LIAB
#this command will kickoff the postinstall script
$OUT/LIAB/postinstall.sh

