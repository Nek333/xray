#!/bin/bash
sudo wget https://github.com/XTLS/Xray-core/releases/download/v1.8.1/Xray-linux-64.zip
sudo unzip ./Xray-linux-64.zip -d ./xray
sudo chmod +x ./xray/xray
sudo cp ./xray/xray.service /usr/lib/systemd/system/xray.service
uuid=$(sudo ./xray/xray uuid)
output=$(sudo ./xray/xray x25519)
private_key=$(echo "$output" | awk '/Private key:/ {print $NF}')
public_key=$(echo "$output" | awk '/Public key:/ {print $NF}')
sudo read -p "Введите сайт для маскировки, в виде www.microsoft.com: " website
sudo systemctl restart xray

