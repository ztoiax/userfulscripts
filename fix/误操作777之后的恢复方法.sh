#!/bin/bash

cd /etc
     chmod 644 passwd group shadow 
     chmod 400 gshadow 
     cd ssh
     chmod  600  moduli  ssh_host_dsa_key ssh_host_key ssh_host_rsa_key 
     chmod  644 ssh_config ssh_host_dsa_key.pub ssh_host_key.pub ssh_host_rsa_key.pub
     chmod  640 sshd_config

    chmod 600 /etc/sscuretty

    chmod 711 /var/empty/sshd

#备份权限
getfacl -R / > ./linux.chmod.bak
#还原权限
cd /
setfacl --restore=/root/linux.chmod.bak 
