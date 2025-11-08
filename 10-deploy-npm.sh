#!/bin/bash
source config.sh

echo "--- 10. Nginx Proxy Manager Dağıtımı ---"
cd $NPM_DIR

# Heredoc kullanarak docker-compose.yml dosyasını oluştur
cat <<EOF > docker-compose.yml
version: '3.8'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: npm
    restart: unless-stopped
    ports:
      - '80:80'
      - '443:443'
      - '81:81'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    networks:
      - proxy-net

networks:
  proxy-net:
    external: true
EOF

echo "NPM yığını başlatılıyor..."
docker compose up -d

echo "--- 10. NPM Dağıtımı Tamamlandı ---"
