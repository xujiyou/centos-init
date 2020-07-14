#!/usr/bin/env bash

# 生成 id_isa 私钥
su s1 -c "ssh-keygen -q -t rsa -N '' <<< ""$'\n'"y" 2>&1"

# 定义远程地址和密码
SERVERS="192.168.225.2 192.168.225.3 192.168.225.4 192.168.225.5 192.168.225.6 192.168.225.7 192.168.225.8 192.168.225.9 192.168.225.10"
PASSWORD="kf-2020"

# 免密登录
auto_ssh_copy_id() {
    su s1 -c "
    expect -c \"set timeout 30;
        spawn ssh-copy-id s1@$1;
        expect {
            *(yes/no)?* {send yes\r;exp_continue;}
            *password:* {send $2\r;exp_continue;}
            eof {exit 0;}
        }\";
    "
}

# 迭代
ssh_copy_id_to_all() {
    for SERVER in $SERVERS
    do
        yum -y install expect
        auto_ssh_copy_id $SERVER $PASSWORD
    done
}

ssh_copy_id_to_all