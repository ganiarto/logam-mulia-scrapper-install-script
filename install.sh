#!/data/data/com.termux/files/usr/bin/bash

# =======================================================
# SCRIPT INSTALLER LOGAM MULIA SCRAPER (FIXED DEPENDENCIES)
# =======================================================

# 1. Persiapan Lingkungan Termux
echo "--- Mengupdate Termux ---"
pkg update -y && pkg upgrade -y
pkg install -y proot-distro git

# 2. Instalasi Ubuntu VM
if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]; then
    echo "--- Menginstal Ubuntu VM ---"
    proot-distro install ubuntu
fi

# 3. Membuat Script Internal untuk Ubuntu
cat << 'EOF' > setup_ubuntu_internal.sh
#!/bin/bash
echo "--- Memulai Konfigurasi di Dalam Ubuntu ---"
apt update -y && apt upgrade -y

# Install Python dan Library Dasar
echo "--- Menginstal Python dan Library Dasar ---"
apt install -y python3 python3-pip python3-venv python3-full git wget \
               libnss3 libatk1.0-0 libx11-xcb1 \
               libxcomposite1 libxdamage1 libxrandr2 \
               libgbm1 libasound2t64 fonts-liberation

# Install Playwright Dependencies Manual (Ganti playwright install-deps)
echo "--- Menginstal Playwright Dependencies Manual ---"
apt-get install -y libatk-bridge2.0-0t64 \
                   libcups2t64 \
                   libxkbcommon0 \
                   libatspi2.0-0t64 \
                   libxfixes3 \
                   libcairo2 \
                   libpango-1.0-0

# Setup Virtual Environment
cd ~
echo "--- Membuat Virtual Environment ---"
rm -rf ~/venv
python3 -m venv ~/venv
source ~/venv/bin/activate

# Clone Repository
cd ~
if [ ! -d "logam-mulia-scrapper" ]; then
    echo "--- Mendownload Repository Scraper ---"
    git clone https://github.com/ganiarto/logam-mulia-scrapper.git
fi

# Install Python Libraries
cd ~/logam-mulia-scrapper
echo "--- Menginstal Library Python ---"
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi
pip install scrapy-playwright fastapi uvicorn

# Install Browser Playwright
echo "--- Menginstal Browser Chromium ---"
playwright install chromium

echo "-------------------------------------------------------"
echo "✅ SETUP BERHASIL!"
echo "-------------------------------------------------------"
echo "Jalankan perintah ini untuk masuk:"
echo "proot-distro login ubuntu"
echo ""
echo "Setelah masuk, jalankan server dengan:"
echo "source ~/venv/bin/activate"
echo "cd ~/logam-mulia-scrapper"
echo "uvicorn api:app --host 0.0.0.0 --port 8100"
echo "-------------------------------------------------------"
EOF

# 4. Memindahkan Script ke Dalam Ubuntu
mv setup_ubuntu_internal.sh $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/

# 5. Eksekusi Otomatis Setup di Dalam Ubuntu
echo "--- Menjalankan Setup di Ubuntu VM (Mohon Tunggu...) ---"
proot-distro login ubuntu -- bash /root/setup_ubuntu_internal.sh