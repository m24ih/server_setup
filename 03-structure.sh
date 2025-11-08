#!/bin/bash
source config.sh

echo "--- 3. Klasör Yapısı Oluşturuluyor ---"

# Ana klasörler (config.sh dosyasından yolları alır)
mkdir -p $MAIN_STACK_DIR/config
mkdir -p $NPM_DIR
mkdir -p $MEDIA_DIR/{movies,tv,downloads,sync}
mkdir -p $WEBSITE_DIR
mkdir -p $LOG_DIR

# Proje klasörlerini de oluşturalım (içleri boş olacak)
mkdir -p $BITES_APP_DIR

echo "Klasör yapısı /home/$USERNAME altında oluşturuldu."
echo "--- 3. Klasör Yapısı Tamamlandı ---"
