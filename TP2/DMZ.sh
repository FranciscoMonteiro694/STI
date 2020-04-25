#!/bin/bash

systemctl stop firewalld
systemctl disable iptables
route add -net 87.248.214.0 netmask 255.255.255.0 gw 23.214.219.254
route add -net 192.168.10.0 netmask 255.255.255.0 gw 23.214.219.254
