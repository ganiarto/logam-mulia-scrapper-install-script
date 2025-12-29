#!/bin/bash
# Ubuntu VM: Install Scraper Environment

echo "Mengupdate sistem..."
apt update -y && apt upgrade -y

# 1. Install System Dependencies
echo "Menginstal dependencies sistem..."
apt install -y python3 python3-pip python3-venv python3-full git wget \
               libnss3 libatk1.0-0 libx11-xcb1 \
               libxcomposite1 libxdamage1 libxrandr2 \
               libgbm1 libasound2t64 fonts-liberation

# 2. Setup Virtual Environment
echo "Membuat Virtual Environment..."
rm -rf ~/venv
python3 -m venv ~/venv
source ~/venv/bin/activate

# 3. Upgrade Pip
pip install --upgrade pip

# 4. Clone Project
cd ~
if [ ! -d "logam-mulia-scrapper" ]; then
    echo "Cloning repository..."
    git clone https://github.com/ganiarto/logam-mulia-scrapper.git
fi
cd logam-mulia-scrapper

# 5. Install Requirements
if [ -f "requirements.txt" ]; then
    echo "Menginstal dependencies dari requirements.txt..."
    pip install -r requirements.txt
    # Pastikan fastapi & uvicorn ada untuk running server
    pip install fastapi uvicorn 
else
    echo "requirements.txt tidak ditemukan, menginstal library standar..."
    pip install scrapy scrapy-playwright fastapi uvicorn
fi

# 6. Install Playwright Browser
echo "Menginstal browser Playwright..."
playwright install chromium

echo ""
echo "-------------------------------------------------------"
echo "✅ SETUP SELESAI!"
echo "-------------------------------------------------------"
echo "Untuk menjalankan API Server, ikuti langkah ini:"
echo "1. Masuk ke folder project:"
echo "   cd ~/logam-mulia-scrapper"
echo ""
echo "2. Jalankan perintah server:"
echo "   uvicorn api:app --host 0.0.0.0 --port 8100"
echo ""
echo "3. Akses API melalui browser HP kamu di:"
echo "   http://localhost:8100"
echo "-------------------------------------------------------"