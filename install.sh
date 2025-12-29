#!/data/data/com.termux/files/usr/bin/bash
# Termux -> Ubuntu VM + Scrapy + Playwright + FastAPI Setup

# 1️⃣ Update Termux & install proot-distro
pkg update -y && pkg upgrade -y
pkg install -y proot-distro wget tar git

# 2️⃣ Pilih versi Ubuntu
UBUNTU_VERSION="22.04"

echo "Menginstal Ubuntu $UBUNTU_VERSION..."
proot-distro install ubuntu-$UBUNTU_VERSION
echo "Ubuntu $UBUNTU_VERSION siap! Masuk dengan:"
echo "proot-distro login ubuntu-$UBUNTU_VERSION"

# 3️⃣ Buat script setup di Ubuntu
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

echo "✅ Script setup_ubuntu_scraper.sh siap dijalankan di Ubuntu VM."
echo "1️⃣ Masuk ke Ubuntu: proot-distro login ubuntu-$UBUNTU_VERSION"
echo "2️⃣ Jalankan setup: ./setup_ubuntu_scraper.sh"
