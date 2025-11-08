#!/bin/bash
source config.sh

echo "--- 12. Bites CPU Analizi Uygulaması Dağıtımı ---"
cd $BITES_APP_DIR

# Proje dosyalarının kopyalandığını varsayıyoruz.
# Dockerfile'ın varlığını kontrol edelim.
if [ ! -f "Dockerfile" ]; then
    echo "HATA: $BITES_APP_DIR/Dockerfile bulunamadı."
    echo "Lütfen önce staj projenizin dosyalarını (Dockerfile, 4_app.py vb.)"
    echo "Bu klasöre kopyalayın ve betiği tekrar çalıştırın."
    exit 1
fi

# Uygulamanın compose dosyasını oluştur
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  bites-cpu-app:
    build: .
    container_name: bites-cpu-app
    networks:
      - proxy-net
    restart: unless-stopped

networks:
  proxy-net:
    external: true
EOF

echo "Bites CPU Analizi uygulaması inşa ediliyor ve başlatılıyor..."
# --build bayrağı Dockerfile'dan imajı oluşturur
docker compose up -d --build

echo "--- 12. Bites CPU Uygulaması Tamamlandı ---"
