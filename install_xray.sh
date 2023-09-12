#!/bin/bash
sudo wget https://github.com/XTLS/Xray-core/releases/download/v1.8.1/Xray-linux-64.zip
sudo mkdir ./xray
sudo unzip ./Xray-linux-64.zip -d ./xray
sudo chmod +x ./xray/xray
sudo cp ./xray.service /usr/lib/systemd/system/xray.service
uuid=$(sudo /usr/local/bin/xray uuid)
output=$(sudo /usr/local/bin/xray x25519)
private_key=$(echo "$output" | awk '/Private key:/ {print $NF}')
public_key=$(echo "$output" | awk '/Public key:/ {print $NF}')
sudo read -p "Введите сайт для маскировки, в виде www.microsoft.com: " website
sudo cp ./config.json ./xray/config.json 
sudo systemctl restart xrayy

