systemctl stop firewalld 
systemctl disable firewalld 
systemctl mask firewalld 
systemctl enable iptables

iptables -F

#DNS
iptables -A INPUT -p udp --sport domain -j ACCEPT
iptables -A OUTPUT -p udp --dport domain -j ACCEPT


#SSH
iptables -A INPUT -s vpn-gw -p tcp --dport ssh -j ACCEPT
iptables -A OUTPUT -d vpn-gw -p tcp --sport ssh -j ACCEPT
iptables -A INPUT -s 192.168.10.0/24 -p tcp --dport ssh -j ACCEPT
iptables -A OUTPUT -d 192.168.10.0/24 -p tcp --sport ssh -j ACCEPT


#Parte 2
#DNS
#internal network
iptables -A FORWARD -s 192.168.10.0/24 -d 23.214.219.133 -p udp --dport domain -i enp0s8 -o enp0s9 -j ACCEPT 
iptables -A FORWARD -s 23.214.219.133 -d 192.168.10.0/24 -p udp --dport domain -i enp0s9 -o enp0s8 -j ACCEPT

#internet
iptables -A FORWARD -s 87.248.214.0/24 -d 23.214.219.133 -p udp --dport domain -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.133 -d 87.248.214.0/24 -p udp --dport domain -i enp0s9 -o enp0s10 -j ACCEPT

#Dns resolve names to other dns servers
iptables -A FORWARD -s 23.214.219.133 -d 87.248.214.0/24 -p udp --dport domain -i enp0s9 -o enp0s10 -j ACCEPT
iptables -A FORWARD -s 87.248.214.0/24 -d 23.214.219.133 -p udp --dport domain -i enp0s10 -o enp0s9 -j ACCEPT

#Sync dns zones
# DNS -> DNS2 
iptables -A FORWARD -s 23.214.219.133 -d 87.248.214.1 -p tcp --dport domain -i enp0s9 -o enp0s10 -j ACCEPT
iptables -A FORWARD -s 87.248.214.1 -d 23.214.219.133 -p tcp --sport domain -i enp0s10 -o enp0s9 -j ACCEPT 

# DNS2 -> DNS
iptables -A FORWARD -s 87.248.214.1 -p tcp -d 23.214.219.133 --dport domain -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.133 -p tcp -d 87.248.214.1 --sport domain -i enp0s9 -o enp0s10 -j ACCEPT

#SMTP connections
# internal
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -d 23.214.219.132 --dport smtp -i enp0s8 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.132 -p tcp -d 192.168.10.0/24 --sport smtp -i enp0s9 -o enp0s8 -j ACCEPT

# internet
iptables -A FORWARD -s 87.248.214.0/24 -p tcp -d 23.214.219.132 --dport smtp -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.132 -p tcp -d 87.248.214.0/24 --sport smtp -i enp0s9 -o enp0s10 -j ACCEPT


#IMAP e POP

# Internal network
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -d 23.214.219.134 --dport pop3 -i enp0s8 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -d 23.214.219.134 --dport imap -i enp0s8 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.134 -p tcp -d 192.168.10.0/24 --sport pop3 -i enp0s9 -o enp0s8 -j ACCEPT
iptables -A FORWARD -s 23.214.219.134 -p tcp -d 192.168.10.0/24 --sport imap -i enp0s9 -o enp0s8 -j ACCEPT

#internet
iptables -A FORWARD -s 87.248.214.0/24 -p tcp -d 23.214.219.134 --dport pop3 -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 87.248.214.0/24 -p tcp -d 23.214.219.134 --dport imap -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.134 -p tcp -d 87.248.214.0/24 --sport pop3 -i enp0s9 -o enp0s10 -j ACCEPT
iptables -A FORWARD -s 23.214.219.134 -p tcp -d 87.248.214.0/24 --sport imap -i enp0s9 -o enp0s10 -j ACCEPT

#HTTP e HTTPS
#Internal network
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -d 23.214.219.131 --dport http -i enp0s8 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -d 23.214.219.131 --dport https -i enp0s8 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.131 -p tcp -d 192.168.10.0/24 --sport http -i enp0s9 -o enp0s8 -j ACCEPT
iptables -A FORWARD -s 23.214.219.131 -p tcp -d 192.168.10.0/24 --sport https -i enp0s9 -o enp0s8 -j ACCEPT

#Internet
iptables -A FORWARD -s 87.248.214.0/24 -p tcp -d 23.214.219.131 --dport http -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 87.248.214.0/24 -p tcp -d 23.214.219.131 --dport https -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.131 -p tcp -d 87.248.214.0/24 --sport http -i enp0s9 -o enp0s10 -j ACCEPT
iptables -A FORWARD -s 23.214.219.131 -p tcp -d 87.248.214.0/24 --sport https -i enp0s9 -o enp0s10 -j ACCEPT

#OPENVPN

# Internal network (UDP)
iptables -A FORWARD -s 192.168.10.0/24 -p udp -d 23.214.219.130 --dport openvpn -i enp0s8 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.130 -p udp -d 192.168.10.0/24 --sport openvpn -i enp0s9 -o enp0s8 -j ACCEPT

# Internal network (TCP)
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -d 23.214.219.130 --dport openvpn -i enp0s8 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.130 -p tcp -d 192.168.10.0/24 --sport openvpn -i enp0s9 -o enp0s8 -j ACCEPT

#Internet (UDP)
iptables -A FORWARD -s 87.248.214.0/24 -p udp -d 23.214.219.130 --dport openvpn -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.130 -p udp -d 87.248.214.0/24 --sport openvpn -i enp0s9 -o enp0s10 -j ACCEPT

#Internet (TCP)
iptables -A FORWARD -s 87.248.214.0/24 -p tcp -d 23.214.219.130 --dport openvpn -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.130 -p tcp -d 87.248.214.0/24 --sport openvpn -i enp0s9 -o enp0s10 -j ACCEPT

# OPENVPN DATASTORE
iptables -A FORWARD -s 23.214.219.130 -p tcp -d 192.168.10.3 --dport postgres -i enp0s9 -o enp0s8 -j ACCEPT
iptables -A FORWARD -s 192.168.10.3 -p tcp -d 23.214.219.130 --sport postgres -i enp0s8 -o enp0s9 -j ACCEPT

#PARTE 3

#FTP
#active mode
iptables -A FORWARD -d 192.168.10.2 -p tcp -i enp0s10 -o enp0s8 --dport ftp -j ACCEPT 
iptables -A FORWARD -s 192.168.10.2 -p tcp -i enp0s8 -o enp0s10 --sport ftp -j ACCEPT
iptables -A FORWARD -d 192.168.10.2 -p tcp -i enp0s10 -o enp0s8 --dport ftp-data -j ACCEPT 
iptables -A FORWARD -s 192.168.10.2 -p tcp -i enp0s8 -o enp0s10 --sport ftp-data -j ACCEPT
iptables -A FORWARD -d 192.168.10.2 -p tcp -i enp0s10 -o enp0s8 --dport 2000:2050 -j ACCEPT 
iptables -A FORWARD -s 192.168.10.2 -p tcp -i enp0s8 -o enp0s10 --sport 2000:2050 -j ACCEPT
#passive mode
iptables -A FORWARD -i enp0s10 -m state --state RELATED,ESTABLISHED -j ACCEPT 
modprobe ip_conntrack_ftp
modprobe ip_nat_ftp

iptables -t nat -A PREROUTING -d 87.248.214.97 -p tcp --dport ftp -j DNAT --to-destination 192.168.10.2
iptables -t nat -A PREROUTING -d 87.248.214.97 -p tcp --dport ftp-data -j DNAT --to-destination 192.168.10.2
iptables -t nat -A PREROUTING -d 87.248.214.97 -p tcp --dport 2000:2050 -j DNAT --to-destination 192.168.10.2


#SSH connections
#eden 
iptables -A FORWARD -s 87.248.214.2 -d 192.168.10.3 -p tcp --dport ssh -j ACCEPT
iptables -A FORWARD -s 192.168.10.3 -p tcp --sport ssh -j ACCEPT
iptables -t nat -A PREROUTING -s 87.248.214.2 -d 87.248.214.97 -p tcp --dport ssh -j DNAT --to-destination 192.168.10.3 


#dns2 
iptables -A FORWARD -s 87.248.214.1 -d 192.168.10.3 -p tcp --dport ssh -j ACCEPT
iptables -A FORWARD -s 192.168.10.3 -p tcp --sport ssh -j ACCEPT
iptables -t nat -A PREROUTING -s 87.248.214.1 -d 87.248.214.97 -p tcp --dport ssh -j DNAT --to-destination 192.168.10.3 


#PARTE 3.2
#DNS
iptables -A FORWARD -s 192.168.10.0/24 -p udp --dport domain -o enp0s10 -j ACCEPT
iptables -A FORWARD -i enp0s10 -d 192.168.10.0/24 -p udp --sport domain -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp0s10  -p udp --dport domain -j SNAT --to-source 87.248.214.97

#HTTP, HTTPS and SSH connections
#http
iptables -A FORWARD -s 192.168.10.0/24 -p tcp --dport http -o enp0s10 -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp0s10 -p tcp --dport http -j SNAT --to-source 87.248.214.97

#https
iptables -A FORWARD -s 192.168.10.0/24 -p tcp --dport https -o enp0s10 -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp0s10 -p tcp --dport https -j SNAT --to-source 87.248.214.97

#ssh
iptables -A FORWARD -s 192.168.10.0/24 -p tcp --dport ssh -o enp0s10 -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp0s10 -p tcp --dport ssh -j SNAT --to-source 87.248.214.97

#para todos
iptables -A FORWARD -d 192.168.10.0/24 -p tcp ! --syn -j ACCEPT

#ftp
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -o enp0s10 --dport ftp -j ACCEPT 
iptables -A FORWARD -d 192.168.10.0/24 -p tcp -i enp0s10 --sport ftp -j ACCEPT
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -o enp0s10 --dport ftp-data -j ACCEPT 
iptables -A FORWARD -d 192.168.10.0/24 -p tcp -i enp0s10 --sport ftp-data -j ACCEPT
iptables -A FORWARD -s 192.168.10.0/24 -p tcp -o enp0s10 --dport 2000:2050 -j ACCEPT 
iptables -A FORWARD -d 192.168.10.0/24 -p tcp -i enp0s10 --sport 2000:2050 -j ACCEPT

#passive mode
iptables -A FORWARD -i enp0s8 -m state --state RELATED,ESTABLISHED -j ACCEPT 
modprobe ip_conntrack_ftp 
modprobe ip_nat_ftp

iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp0s10 -p tcp --dport ftp -j SNAT --to-source 87.248.214.97
#adicionei isto
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp0s10 -p tcp --dport ftp-data -j SNAT --to-source 87.248.214.97
iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -o enp0s10 -p tcp --dport 2000:2050 -j SNAT --to-source 87.248.214.97


#dar drop a tudo
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP




