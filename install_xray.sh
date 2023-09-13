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

# Создаем временный файл конфигурации
cat <<EOL > /root/xray/temp_config.json
{
  "log": {
    "loglevel": "info"
  },
  "routing": {
    "rules": [],
    "domainStrategy": "AsIs"
  },
  "inbounds": [
    {
      "port": 23,
      "tag": "ss",
      "protocol": "shadowsocks",
      "settings": {
        "method": "2022-blake3-aes-128-gcm",
        "password": "qweqweqweqeqweqe",
        "network": "tcp,udp"
      }
    },
    {
      "port": 443,
      "protocol": "vless",
      "tag": "vless_tls",
      "settings": {
        "clients": [
          {
            "id": "$uuid",
            "email": "user1@myserver",
            "flow": "xtls-rprx-vision"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "tcp",
        "security": "reality",
        "realitySettings": {
          "show": false,
          "dest": "$website:443",
          "xver": 0,
          "serverNames": [
            "$website"
          ],
          "privateKey": "$private_key",
          "minClientVer": "",
          "maxClientVer": "",
          "maxTimeDiff": 0,
          "shortIds": [
            "aabbccdd"
          ]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "tag": "block"
    }
  ]
}
EOL

# Заменяем конфигурационный файл
mv /root/xray/temp_config.json /root/xray/config.json

sudo systemctl restart xray
echo "Скопируйте публичный ключ: $public_key"
echo "Скопируйте ID: $uuid"

