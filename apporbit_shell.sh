#!/bin/bash

if [[ -n "$1" ]]; then
  # "$1" is not empty. This is the part which runs when one or more
  # arguments are supplied.
  #
  while [[ -n "$1" ]]; do
    case "$1" in
        -c )                    cat /proc/cpuinfo | grep cores
                                ;;
        -d )                    fdisk -l | grep Disk  | awk '{print $1,$2,$3,$4}' #fdisk -l 2> /dev/null | grep Disk | grep -v identifier
                                ;;
        -p )                    #result will get all the processes currently running and will also include
                                #process count genereated by ps, wc and echo and will subtract that from
                                #actual running processes
                                result=$(ps -aux | wc -l)
                                x=$((result - 4))
                                echo Number of Running Process: $x
                                ;;
        -l )                    #Listing Processes running on exteral ports
                                netstat -tulpn | awk '$4 ~ /Local/ {print $0}'
                                netstat -tulpn | awk '$4 ~ /0.0.0.0/ {print $0}'
                                ;;
        -s )                    #SELinux
                                sestatus | grep SELinux status
                                ;;
        -f )                    #Firewall
                                DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
                                if [ $DISTRO == Ubuntu ] || [$DISTRO == Debian ]; then
                                  echo Firewall $(ufw status) # Ubuntu
                                elif [ $DISTRO == Fedora || CentOS || Red Hat ]; then
                                  service iptables status
                                fi
                                ;;
        -m )                    if [[ $2 == g ]]; then
                                 awk '$3=="kB"{$2=$2/1024/1024;$3="GB"} 1' /proc/meminfo | column -t | grep Mem*
                                elif [[ $2 == m ]]; then
                                 awk '$3=="kB"{$2=$2/1024;$3="MB"} 1' /proc/meminfo | column -t | grep Mem*
                                elif [[ $2 == k ]]; then
                                 awk '$3=="kB"{$2=$2;$3="KB"} 1' /proc/meminfo | column -t | grep Mem*
                                else
                                 echo Invalid or Wrong Arguement. Plesae specify -m and g, m, k for GB, MB and KB resp
                                fi
                                ;;

    esac 
   shift
  done
 exit
fi
#
# "$1" is empty. The following code runs when no arguments are supplied.
#
cat /proc/cpuinfo | grep cores
fdisk -l | grep Disk  | awk '{print $1,$2,$3,$4}' #fdisk -l 2> /dev/null | grep Disk | grep -v identifier
result=$(ps -aux | wc -l)
x=$((result - 4))
echo Number of Running Process: $x
netstat -tulpn | awk '$4 ~ /Local/ {print $0}'
netstat -tulpn | awk '$4 ~ /0.0.0.0/ {print $0}'
sestatus | grep SELinux status
DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
if [ $DISTRO == Ubuntu ] || [$DISTRO == Debian ]; then
  ufw status # Ubuntu
elif [ $DISTRO == Fedora || CentOS || Red Hat ]; then
  service iptables status
fi
awk '$3=="kB"{$2=$2/1024/1024;$3="GB"} 1' /proc/meminfo | column -t | grep Mem*
