#!/bin/bash
source config.sh

echo "--- 2. Docker Kurulumu Başlatılıyor ---"

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Kullanıcıyı 'docker' grubuna ekle
sudo usermod -aG docker $USERNAME

echo "--- 2. Docker Kurulumu Tamamlandı ---"
echo "!!! ÖNEMLİ: Değişikliklerin etkili olması için terminali kapatıp YENİDEN BAĞLANIN!"
echo "Yeniden bağlandıktan sonra 3. betiği çalıştırın."
