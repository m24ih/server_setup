#!/bin/bash
source config.sh

echo "--- 20. Rclone Systemd Servisleri Oluşturuluyor ---"

# Film Servisi
sudo cat <<EOF > /etc/systemd/system/rclone-movies.service
[Unit]
Description=Rclone Mount for GDrive Movies
AssertPathIsDirectory=$MEDIA_DIR/movies
After=network-online.target

[Service]
Type=simple
User=$USERNAME
Group=$USERNAME
ExecStart=/usr/bin/rclone mount $GDRIVE_MOVIES_PATH $MEDIA_DIR/movies \
    --allow-other \
    --dir-cache-time 96h \
    --vfs-read-chunk-size 64M \
    --vfs-cache-mode writes \
    --vfs-cache-max-size 10G \
    --buffer-size 32M \
    --timeout 1h \
    --log-level INFO \
    --log-file $LOG_DIR/rclone-movies.log
ExecStop=/bin/fusermount -uz $MEDIA_DIR/movies
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

# Dizi Servisi
sudo cat <<EOF > /etc/systemd/system/rclone-tv.service
[Unit]
Description=Rclone Mount for GDrive TV
AssertPathIsDirectory=$MEDIA_DIR/tv
After=network-online.target

[Service]
Type=simple
User=$USERNAME
Group=$USERNAME
ExecStart=/usr/bin/rclone mount $GDRIVE_TV_PATH $MEDIA_DIR/tv \
    --allow-other \
    --dir-cache-time 96h \
    --vfs-read-chunk-size 64M \
    --vfs-cache-mode writes \
    --vfs-cache-max-size 10G \
    --buffer-size 32M \
    --timeout 1h \
    --log-level INFO \
    --log-file $LOG_DIR/rclone-tv.log
ExecStop=/bin/fusermount -uz $MEDIA_DIR/tv
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

echo "Systemd servis dosyaları oluşturuldu."
echo "--- ÖNEMLİ EYLEM GEREKİYOR ---"
echo "Rclone servislerini başlatmadan ÖNCE, Docker yığınlarınızı durdurun:"
echo "cd $MAIN_STACK_DIR && docker compose down"
echo ""
echo "Ardından Rclone servislerini etkinleştirin ve başlatın:"
echo "sudo systemctl daemon-reload"
echo "sudo systemctl enable --now rclone-movies.service"
echo "sudo systemctl enable --now rclone-tv.service"
echo ""
echo "Dosyaların bağlandığını 'ls $MEDIA_DIR/movies' ile kontrol edin."
echo "Son olarak Docker yığınınızı yeniden başlatın:"
echo "cd $MAIN_STACK_DIR && docker compose up -d"
echo ""
echo "--- 20. Rclone Servisleri Tamamlandı ---"
