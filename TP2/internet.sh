#!/bin/bash

systemctl stop firewalld
systemctl disable iptables
route add -net 23.214.219.128 netmask 255.255.255.128 gw 87.248.214.97
route add -net 192.168.10.0 netmask 255.255.255.0 gw 87.248.214.97