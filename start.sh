#!/usr/bin/env bash

SERVERS="192.168.225.2 192.168.225.3 192.168.225.4 192.168.225.5 192.168.225.6 192.168.225.7 192.168.225.8 192.168.225.9 192.168.225.10"
PASSWORD="kf-2020"

# 将脚本拷贝到全部机器
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

# 执行初始化脚本
ssh_exec_to_other() {
  ID="$(echo $1 | awk -F. '{print $NF}')"
  expect -c "
  set timeout 30;
  spawn ssh root@$1 'bash /root/init.sh server-0$((ID-1))'
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
        ssh_exec_to_other $SERVER
    done
}

scp_copy_to_all

# 执行免密脚本
ssh_exec_nopass_to_other() {
  expect -c "
  set timeout 30;
  spawn ssh root@$1 'bash /root/nopass-login.sh'
  expect {
    *password:* {send $PASSWORD\r; exp_continue;}
    *(yes/no)?* {send yes\r; exp_continue;}
    eof {exit 0;}
  }"
}

nopass_to_all() {
  for SERVER in $SERVERS
    do
      ssh_exec_nopass_to_other $SERVER
    done
}

nopass_to_all