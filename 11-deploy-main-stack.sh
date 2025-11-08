#!/bin/bash
source config.sh

echo "--- 11. Ana Medya Yığını Dağıtımı ---"
cd $MAIN_STACK_DIR

# Heredoc ile ana docker-compose.yml dosyasını oluştur
cat <<EOF > docker-compose.yml
---
version: "3.8"

services:

  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TIMEZONE
    volumes:
      - $MAIN_STACK_DIR/config/jellyfin:/config
      - $MEDIA_DIR/tv:/data/tvshows
      - $MEDIA_DIR/movies:/data/movies
    networks:
      - default
      - proxy-net
    restart: unless-stopped

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TIMEZONE
    volumes:
      - $MAIN_STACK_DIR/config/sonarr:/config
      - $MEDIA_DIR:/media
      - $MEDIA_DIR/downloads:/downloads
    networks:
      - default
      - proxy-net
    restart: unless-stopped

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TIMEZONE
    volumes:
      - $MAIN_STACK_DIR/config/radarr:/config
      - $MEDIA_DIR:/media
      - $MEDIA_DIR/downloads:/downloads
    networks:
      - default
      - proxy-net
    restart: unless-stopped

  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TIMEZONE
    volumes:
      - $MAIN_STACK_DIR/config/prowlarr:/config
    networks:
      - default
      - proxy-net
    restart: unless-stopped

  bazarr:
    image: lscr.io/linuxserver/bazarr:latest
    container_name: bazarr
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TIMEZONE
    volumes:
      - $MAIN_STACK_DIR/config/bazarr:/config
      - $MEDIA_DIR:/media
    networks:
      - default
      - proxy-net
    restart: unless-stopped

  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TIMEZONE
      - WEBUI_PORT=8080
      - WEBUI_PORT_FORWARDING=true
    volumes:
      - $MAIN_STACK_DIR/config/qbittorrent:/config
      - $MEDIA_DIR/downloads:/downloads
    ports:
      - 8080:8080
      - 6881:6881
      - 6881:6881/udp
    networks:
      - default
      - proxy-net
    restart: unless-stopped

  syncthing:
    image: lscr.io/linuxserver/syncthing:latest
    container_name: syncthing
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TIMEZONE
    volumes:
      - $MAIN_STACK_DIR/config/syncthing:/config
      - $MEDIA_DIR/sync:/data1
    ports:
      - 8384:8384
      - 22000:22000
      - 21027:21027/udp
    networks:
      - default
      - proxy-net
    restart: unless-stopped
    
  freshrss:
    image: lscr.io/linuxserver/freshrss:latest
    container_name: freshrss
    environment:
      - PUID=$PUID
      - PGID=$PGID
      - TZ=$TIMEZONE
    volumes:
      - $MAIN_STACK_DIR/config/freshrss:/config
    ports:
      - 8081:80
    networks:
      - default
      - proxy-net
    restart: unless-stopped

  website:
    image: nginx:alpine
    container_name: website
    volumes:
      - $WEBSITE_DIR:/usr/share/nginx/html:ro
    networks:
      - default
      - proxy-net
    restart: unless-stopped

networks:
  default:
    driver: bridge
  proxy-net:
    external: true
EOF

echo "Ana medya yığını başlatılıyor..."
docker compose up -d

echo "--- 11. Ana Medya Yığını Tamamlandı ---"
