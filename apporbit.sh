#!/bin/bash

cat /proc/meminfo | grep Mem*   #free

cat /proc/cpuinfo | grep cores  # lscpu, nproc

fdisk -l | grep Disk  #fdisk -l 2> /dev/null | grep Disk | grep -v identifier

#result will get all the processes currently running and will also include
#process count genereated by ps, wc and echo and will subtract that from
#actual running processes
result=$(ps -aux | wc -l)
x=$((result - 4))
echo $x

#Listing Processes running on exteral ports
netstat -tulpn | awk '$4 ~ /Local/ {print $0}'
netstat -tulpn | awk '$4 ~ /0.0.0.0/ {print $0}'

#SELinux
sestatus | grep SELinux status

#Firewall
ufw status # Ubuntu
service iptables status # CentOS, Red Hat
