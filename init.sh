#!/usr/bin/env bash

PASSWORD="kf-2020"

# 系统更新
yum update -y

# 设置主机名
hostnamectl set-hostname $1

# 添加用户 设置密码 添加 sudo 权限
useradd -d /home/s1 -m s1
echo $PASSWORD | passwd --stdin s1
echo 's1 ALL=(ALL)     NOPASSWD:ALL' >> /etc/sudoers

# 设置 hosts
echo "192.168.225.2 server-01" >> /etc/hosts
echo "192.168.225.3 server-02" >> /etc/hosts
echo "192.168.225.4 server-03" >> /etc/hosts
echo "192.168.225.5 server-04" >> /etc/hosts
echo "192.168.225.6 server-05" >> /etc/hosts
echo "192.168.225.7 server-06" >> /etc/hosts
echo "192.168.225.8 server-07" >> /etc/hosts
echo "192.168.225.9 server-08" >> /etc/hosts
echo "192.168.225.10 server-09" >> /etc/hosts


# 关闭防火墙
systemctl stop firewalld
systemctl disable firewalld

# 关闭 SELinux
setenforce 0
sed -i '/SELINUX/s/enforcing/disabled/g' /etc/selinux/config







