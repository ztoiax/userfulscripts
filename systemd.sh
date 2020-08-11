#!/bin/bash
# ip
cat > /etc/systemd/network/10-static-eth0.network << "EOF"
[Match]
Name=eth0

[Network]
Address=192.168.0.2/24
Gateway=192.168.0.1
DNS=192.168.0.1
EOF
# dhcp
cat > /etc/systemd/network/10-static-eth0.network << "EOF"
[Match]
Name=eth0

[Network]
Address=192.168.0.2/24
Gateway=192.168.0.1
DNS=192.168.0.1
EOF
# dns
cat > /etc/resolv.conf << "EOF"
nameserver 223.5.5.5
nameserver 114.114.114.114
EOF
cat > /etc/systemd/resolved.conf << "EOF"
[Resolve]
DNS=223.5.5.5 114.114.114.114
DNSOverTLS=yes
DNSSEC=yes
FallbackDNS=8.8.8.8 1.0.0.1 8.8.4.4
#Domains=~.
#LLMNR=yes
#MulticastDNS=yes
Cache=yes
#DNSStubListener=yes
#ReadEtcHosts=yes
EOF

# hosts
cat > /etc/hosts << "EOF"
127.0.0.1 localhost
::1       localhost
EOF
