#!/bin/bash
# Ubuntu VM: Install Scraper Environment (Updated for Ubuntu 24.04+)

echo "Mengupdate sistem..."
apt update -y && apt upgrade -y

# 1. Install System Dependencies (Ganti libasound2 ke libasound2t64)
echo "Menginstal dependencies sistem..."
apt install -y python3 python3-pip python3-venv python3-full git wget \
               libnss3 libatk1.0-0 libx11-xcb1 \
               libxcomposite1 libxdamage1 libxrandr2 \
               libgbm1 libasound2t64 fonts-liberation

# 2. Hapus venv lama jika gagal, lalu buat baru
echo "Membuat Virtual Environment..."
rm -rf ~/venv
python3 -m venv ~/venv

# 3. Masuk ke Virtual Environment
source ~/venv/bin/activate

# 4. Install Python packages di dalam venv
echo "Menginstal library Python (Scrapy, Playwright, FastAPI)..."
pip install --upgrade pip
pip install scrapy scrapy-playwright fastapi uvicorn

# 5. Install Playwright Browser
echo "Menginstal browser Playwright..."
playwright install chromium

# 6. Setup Project
cd ~
if [ ! -d "logam-mulia-scrapper" ]; then
    echo "Cloning repository..."
    git clone https://github.com/ganiarto/logam-mulia-scrapper.git
fi
cd logam-mulia-scrapper

echo "------------------------------------------------"
echo "✅ SETUP BERHASIL!"
echo "------------------------------------------------"
echo "Untuk menjalankan aplikasi nantinya:"
echo "1. Masuk Ubuntu: proot-distro login ubuntu"
echo "2. Aktifkan Venv: source ~/venv/bin/activate"
echo "3. Jalankan Scraper/API di folder project."