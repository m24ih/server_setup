#!/bin/bash
source config.sh

echo "--- 4. Docker Proxy Ağı Oluşturuluyor ---"

# 'proxy-net' ağının zaten var olup olmadığını kontrol et
if ! docker network ls | grep -q "proxy-net"; then
  docker network create proxy-net
  echo "'proxy-net' ağı oluşturuldu."
else
  echo "'proxy-net' ağı zaten mevcut. Atlınıyor."
fi

echo "--- 4. Docker Proxy Ağı Tamamlandı ---"
