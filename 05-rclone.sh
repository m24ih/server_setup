#!/bin/bash
source config.sh

echo "--- 5. Rclone Kurulumu ve FUSE Ayarı ---"
sudo apt install -y rclone

# FUSE ayarı (allow-other için)
sudo sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf
echo "Rclone kuruldu ve /etc/fuse.conf ayarlandı."

echo "--- MANUEL EYLEM GEREKİYOR ---"
echo "Lütfen şimdi 'rclone config' komutunu manuel olarak çalıştırın."
echo "Remote adını '$RCLONE_REMOTE_NAME' olarak ayarladığınızdan emin olun."
echo "Tamamladıktan sonra 10-deploy-npm.sh betiğine geçebilirsiniz."
echo "Rclone servisleri (20-rclone-services.sh) en son çalıştırılacak."
