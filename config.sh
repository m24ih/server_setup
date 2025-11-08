#!/bin/bash

# --- TEMEL AYARLAR ---
# Bu betikleri çalıştıran sudo yetkisine sahip kullanıcı
USERNAME="melih"

# id komutundan aldığınız PUID ve PGID değerleri
PUID="1000"
PGID="1000"

# Sunucunuzun saat dilimi
TIMEZONE="Europe/Istanbul"

# --- RCLONE AYARLARI ---
# 'rclone config' ile oluşturduğunuz remote'un adı
RCLONE_REMOTE_NAME="gdrive"

# GDrive'ınızdaki film ve dizi klasörlerinizin tam yolu
GDRIVE_MOVIES_PATH="gdrive:/server-media/movies"
GDRIVE_TV_PATH="gdrive:/server-media/tv"

# --- PROJE KLASÖRLERİ (Referans) ---
# Diğer betikler bu değişkenleri kullanarak doğru yerlerde çalışacak
# (Bunları değiştirmenize gerek yok)
BASE_DIR="/home/$USERNAME"
NPM_DIR="$BASE_DIR/npm"
MAIN_STACK_DIR="$BASE_DIR/docker"
BITES_APP_DIR="$BASE_DIR/Bites_CPU_Analizi"
LOG_DIR="$BASE_DIR/logs"
MEDIA_DIR="$BASE_DIR/media"
WEBSITE_DIR="$BASE_DIR/website"
