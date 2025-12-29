#!/data/data/com.termux/files/usr/bin/bash
# Termux -> Ubuntu VM + Scrapy + Playwright + FastAPI Setup

# Update Termux & install proot-distro
pkg update -y && pkg upgrade -y
pkg install -y proot-distro wget tar git

echo "Menginstal Ubuntu"
proot-distro install ubuntu
echo "Ubuntu siap! Masuk dengan:"
echo "proot-distro login ubuntu"

# Buat script setup di Termux (host)
cat << 'EOF' > setup_ubuntu_scraper.sh
#!/bin/bash
# Ubuntu VM: Install Scraper Environment

# Update & install system packages
apt update -y && apt upgrade -y
apt install -y python3 python3-pip git wget \
               chromium chromium-driver \
               libnss3 libatk1.0-0 libx11-xcb1 \
               libxcomposite1 libxdamage1 libxrandr2 \
               libgbm1 libasound2 fonts-liberation

# Upgrade pip & install Python packages
pip3 install --upgrade pip
pip3 install scrapy scrapy-playwright fastapi uvicorn

# Install Playwright Chromium
playwright install chromium

# Clone scraper repo
git clone https://github.com/ganiarto/logam-mulia-scrapper.git
cd logam-mulia-scrapper

echo "Setup selesai!"
echo "Jalankan scraper: python3 main.py"
echo "Jalankan FastAPI: uvicorn api:app --host 0.0.0.0 --port 8100"
EOF

chmod +x setup_ubuntu_scraper.sh

# Copy script ke Ubuntu VM secara otomatis
echo "Menyalin setup_ubuntu_scraper.sh ke Ubuntu VM..."
proot-distro login ubuntu -- cp /data/data/com.termux/files/home/setup_ubuntu_scraper.sh /root/
proot-distro login ubuntu -- chmod +x /root/setup_ubuntu_scraper.sh

echo "✅ Script sudah disalin ke Ubuntu VM di /root/setup_ubuntu_scraper.sh"
echo "Untuk menjalankan setup di Ubuntu, masuk ke Ubuntu lalu jalankan:"
echo "proot-distro login ubuntu"
echo "/root/setup_ubuntu_scraper.sh"
