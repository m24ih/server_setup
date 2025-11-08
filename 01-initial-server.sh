#!/bin/bash
source config.sh

echo "--- 1. Sunucu Temel Ayarları Başlatılıyor ---"

sudo apt update && sudo apt upgrade -y
# Temel ihtiyaçlar
sudo apt install -y curl gnupg ca-certificates nano git

# Güvenlik Duvarı (UFW)
echo "UFW ayarlanıyor..."
sudo ufw allow OpenSSH  # SSH
sudo ufw allow http     # Port 80
sudo ufw allow https    # Port 443
sudo ufw allow 81/tcp   # NPM Admin Paneli

# UFW'yi etkinleştirmek için sizden onay isteyecek
sudo ufw enable

echo "--- 1. Sunucu Temel Ayarları Tamamlandı ---"
