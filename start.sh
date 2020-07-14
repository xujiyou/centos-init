#!/usr/bin/env bash

SERVERS="192.168.225.2 192.168.225.3 192.168.225.4 192.168.225.5 192.168.225.6 192.168.225.7 192.168.225.8 192.168.225.9"
PASSWORD='kf-2020'

# 将脚本拷贝到全部机器，最后执行
scp_copy_to_other() {
  expect -c "
  set timeout 30;
  spawn scp /root/init.sh /root/nopass-login.sh root@$1:/root
  expect {
    *password:* {send $PASSWORD\r; exp_continue;}
    *(yes/no)?* {send yes\r; exp_continue;}
    eof {exit 0;}
  }"
}

scp_copy_to_all() {
  for SERVER in $SERVERS
    do
        sudo yum -y install expect
        scp_copy_to_other $SERVER
        ID=$(echo $SERVER | awk -F. '{print $NF}')
        ssh root@$SERVER "bash /root/init.sh server-0$((ID-1))"
    done
}

scp_copy_to_all

nopass_to_all() {
  for SERVER in $SERVERS
    do
        ssh root@$SERVER "bash /root/nopass-login.sh"
    done
}

nopass_to_all