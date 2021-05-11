#!/bin/sh
sudo apt install wireguard
sudo ufw allow 61951/udp
echo "Uncomment the following line. net.ipv4.ip_forward=1"
echo "ok? (y)"
read -n
sudo vim /etc/sysctl.conf
sudo sysctl -p
echo "Server Private and public key pairs creation"
wg genkey | sudo tee /etc/wireguard/server_private.key | wg pubkey | sudo tee /etc/wireguard/server_public.key
sudo chmod 600 /etc/wireguard/server_private.key
echo "Client Private and public key pairs creation"
wg genkey | sudo tee /etc/wireguard/client_private.key | wg pubkey | sudo tee /etc/wireguard/client_public.key
sudo chmod 600 /etc/wireguard/client_private.key

server_private=$(cat /etc/wireguard/server_private.key)
client_public=$(cat /etc/wireguard/client_public.key)

tar -czvf client.tar.gz /etc/wireguard/client_*
echo "written ./client.tar.gz"

echo "Wireguard Config"
cat <<EOF > /etc/wireguard/wg0.conf
# Server configuration
[Interface]
PrivateKey = $server_private
Address = 10.5.5.1/24
ListenPort = 61951
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
# Configurations for the clients. You need to add a [Peer] section for each VPN client.
[Peer]
PublicKey = $client_public
AllowedIPs = 10.5.5.2/32
EOF
