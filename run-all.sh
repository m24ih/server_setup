#!/bin/bash
set -e # Herhangi bir komut hata verirse betiği durdur

echo ">>> TÜM MODÜLER KURULUM BAŞLATILIYOR <<<"
echo "Mevcut konum: $(pwd)"
echo "Kullanıcı: $(whoami)"

# Betikleri çalıştırılabilir yap
chmod +x *.sh

echo "--- ADIM 1: TEMEL SUNUCU ---"
./01-initial-server.sh

echo "--- ADIM 2: DOCKER ---"
./02-docker.sh

# Adım 2 kullanıcıdan yeniden bağlanmasını istiyor.
# Bu nedenle bu ana betik burada durmalı.
echo ""
echo ">>> KURULUMUN 1. AŞAMASI TAMAMLANDI <<<"
echo "LÜTFEN terminali kapatıp YENİDEN BAĞLANIN."
echo "Yeniden bağlandığınızda, kalan betikleri manuel olarak çalıştırın:"
echo "cd ~/setup-scripts"
echo "./03-structure.sh"
echo "./04-docker-network.sh"
echo "./05-rclone.sh (ve manuel 'rclone config' yapın)"
echo "./10-deploy-npm.sh"
echo "./11-deploy-main-stack.sh"
echo "./12-deploy-bites-app.sh (önce dosyaları kopyalayın)"
echo "./20-rclone-services.sh (en son)"

exit 0
