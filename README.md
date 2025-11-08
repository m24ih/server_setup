# server_setup
# Kişisel VDS Otomasyon Betikleri (Gelecekteki Melih'e Not)

Bu klasör, Debian 12 (Bookworm) VDS sunucuma format attıktan sonra tüm Docker servis yığınımı (Medya, NPM, Projeler) hızlı ve hatasız bir şekilde yeniden kurmak için gereken modüler otomasyon betiklerini içerir.

## Ön Gereksinimler (Başlamadan Önce)

1.  **Sunucu:** Taze formatlanmış, Debian 12 çalıştıran bir VDS.
2.  **Kullanıcı:** `root` olarak bağlanılmış olmalı (ilk betikler `root` veya `sudo` ile çalışacak).
3.  **Betikler:** Bu betiklerin sunucuda (`~/setup-scripts`) klonlanmış veya kopyalanmış olması gerekir.
4.  **AYARLAMA YAP!:** `config.sh` dosyasını açıp içindeki tüm değişkenleri (Kullanıcı Adı, PUID/PGID, Rclone Yolları) kontrol et.

## Kurulum Sırası (Modüler)

Bu betikler modülerdir ve belirli bir sırayla çalıştırılmalıdır.

### Aşama 1: Temel Sistem ve Docker Kurulumu

1.  Tüm betik dosyalarını çalıştırılabilir yap:
    ```bash
    chmod +x *.sh
    ```
2.  İlk sunucu ayarlarını (UFW, temel paketler) çalıştır:
    ```bash
    sudo ./01-initial-server.sh
    ```
    (UFW'yi etkinleştirmek için `y` onayı isteyecektir)

3.  Resmi Docker kurulumunu çalıştır:
    ```bash
    sudo ./02-docker.sh
    ```

4.  > **!!! KRİTİK MANUEL ADIM !!!**
    > `02-docker.sh` betiği, kullanıcınızı `docker` grubuna ekler. Bu değişikliğin aktif olması için sunucu bağlantınızı **tamamen kapatın (`exit`)** ve `melih` kullanıcısı olarak **yeniden bağlanın.**

### Aşama 2: Docker Altyapısı ve Yığınları (Stack)

*Yeniden bağlandıktan sonra* aşağıdaki komutları `sudo` OLMADAN çalıştırın:

1.  Gerekli tüm klasör yapısını oluştur:
    ```bash
    ./03-structure.sh
    ```
2.  Tüm yığınların konuşmasını sağlayacak `proxy-net` ağını oluştur:
    ```bash
    ./04-docker-network.sh
    ```
3.  Rclone'u kur ve FUSE ayarını yap:
    ```bash
    ./05-rclone.sh
    ```
4.  > **MANUEL ADIM: Rclone Yapılandırması**
    > Betik bittikten sonra `rclone config` komutunu çalıştırarak `gdrive` (veya `config.sh` içinde ne ad verdiyseniz) remote'unuzu yapılandırın.

5.  Nginx Proxy Manager yığınını dağıt ve başlat:
    ```bash
    ./10-deploy-npm.sh
    ```
6.  Ana medya yığınını (Jellyfin, *arrs, vb.) dağıt ve başlat:
    ```bash
    ./11-deploy-main-stack.sh
    ```

### Aşama 3: Özel Uygulamalar ve Veriler

1.  > **MANUEL ADIM: Proje Dosyalarını Yükle**
    > Betiği çalıştırmadan önce `scp`, `rsync` veya `git clone` kullanarak proje dosyalarınızı ilgili klasörlere kopyalayın:
    > * Portfolyo sitenizin dosyalarını (`index.html` vb.) `~/website` klasörüne atın.
    > * Staj projenizin dosyalarını (`Dockerfile`, `4_app.py` vb.) `~/Bites_CPU_Analizi` klasörüne atın.

2.  Staj projenizi "build" et ve dağıt:
    ```bash
    ./12-deploy-bites-app.sh
    ```

### Aşama 4: Rclone Servislerini Etkinleştirme (Son Adım)

Bu, medyanın bağlanması için son adımdır ve dikkat gerektirir.

1.  Rclone için `systemd` servis dosyalarını oluşturmak üzere betiği `sudo` ile çalıştırın:
    ```bash
    sudo ./20-rclone-services.sh
    ```
2.  > **MANUEL ADIM: Rclone Mount İşlemi**
    > Betiğin sonunda yazan talimatları izleyin. Bu talimatlar özetle şunlardır:
    >
    > 1.  Medya klasörlerini kullanan ana yığını durdur:
    >     `cd ~/docker && docker compose down`
    > 2.  Systemd'yi yeniden yükle ve Rclone servislerini başlat:
    >     ```bash
    >     sudo systemctl daemon-reload
    >     sudo systemctl enable --now rclone-movies.service
    >     sudo systemctl enable --now rclone-tv.service
    >     ```
    > 3.  Bağlantıyı doğrula: `ls -l ~/media/movies` (GDrive dosyalarınızı görmelisiniz).
    > 4.  Docker yığınını yeniden başlat:
    >     `cd ~/docker && docker compose up -d`

## Kurulum Sonrası Yapılandırma

1.  **Nginx Proxy Manager:**
    * `http://[SUNUCU_IP]:81` adresine gidin.
    * Giriş yapın (`admin@example.com` / `changeme`) ve **hemen şifrenizi değiştirin.**
2.  **DNS (Cloudflare):**
    * > **UNUTMA: "GRİ BULUT" KURALI**
    >   Tüm `A` kayıtlarınız (`jellyfin`, `sonarr`, `qb`, `bites` vb.) için Cloudflare'deki "Proxy status" (Proxy durumu) **"DNS only" (Gri Bulut)** olmalıdır. Aksi takdirde WebSocket (Streamlit) ve `Unauthorized` (qBit) hataları alırsınız.
3.  **NPM Host Kurulumu:**
    * Her servis (`jellyfin.melihak.me`, `bites.melihak.me` vb.) için NPM'de "Proxy Host" oluşturun.
    * **Forward Hostname / IP:** Servis adını kullanın (örn: `jellyfin`, `bites-cpu-app`).
    * **Forward Port:** Konteynerin iç portunu kullanın (örn: `8096`, `8501`).
    * **SSL:** `Request new SSL Certificate` ve `Force SSL` açın.
    * Streamlit (Bites) için `Websockets Support` düğmesini **AÇIK** konuma getirin.
4.  **Uygulama İçi Ayarlar:**
    * Tüm *arr* uygulamalarının birbirleriyle konuşması için `localhost` yerine servis adlarını kullanın (örn: qBit adresi: `http://qbittorrent:8080`).

## Bakım ve Güncelleme

Sistem çalışırken uygulamaları güncellemek için:

```bash
# Ana yığını güncelle
cd ~/docker
docker compose pull
docker compose up -d

# NPM'i güncelle
cd ~/npm
docker compose pull
docker compose up -d

# Bites projesini (kod değiştiyse) yeniden 'build' et
cd ~/Bites_CPU_Analizi
docker compose up -d --build
