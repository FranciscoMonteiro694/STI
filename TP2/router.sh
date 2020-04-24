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

#Internet (UDP)
iptables -A FORWARD -s 87.248.214.0/24 -p tcp -d 23.214.219.130 --dport openvpn -i enp0s10 -o enp0s9 -j ACCEPT
iptables -A FORWARD -s 23.214.219.130 -p tcp -d 87.248.214.0/24 --sport openvpn -i enp0s9 -o enp0s10 -j ACCEPT

# OPENVPN DATASTORE
iptables -A FORWARD -s 23.214.219.130 -p tcp -d 192.168.10.3 --dport postgres -i enp0s9 -o enp0s8 -j ACCEPT
iptables -A FORWARD -s 192.168.10.3 -p tcp -d 23.214.219.130 --sport postgres -i enp0s8 -o enp0s9 -j ACCEPT


#dar drop a tudo
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP




