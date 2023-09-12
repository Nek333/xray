#!/bin/bash
sudo wget https://github.com/XTLS/Xray-core/releases/download/v1.8.1/Xray-linux-64.zip
sudo unzip ./Xray-linux-64.zip -d ./xray
sudo chmod +x /root/xray/xray
sudo cp ./xray/xray.service /usr/lib/systemd/system/xray.service
sudo systemctl enable xray
uuid=$(sudo /root/xray/xray uuid)
output=$(sudo /root/xray/xray x25519)
private_key=$(echo "$output" | awk '/Private key:/ {print $NF}')
public_key=$(echo "$output" | awk '/Public key:/ {print $NF}')
read -p "Введите сайт для маскировки, в виде www.microsoft.com: " website
sudo systemctl restart xray

