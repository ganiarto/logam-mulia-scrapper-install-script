#!/data/data/com.termux/files/usr/bin/bash
# Termux -> Ubuntu VM + Scrapy + Playwright + FastAPI Setup

# 1. Update Termux & install proot-distro
pkg update -y && pkg upgrade -y
pkg install -y proot-distro wget tar git

# 2. Instal Ubuntu jika belum ada
if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]; then
    echo "Menginstal Ubuntu..."
    proot-distro install ubuntu
else
    echo "Ubuntu sudah terinstal."
fi

# 3. Buat script setup di direktori Home Termux
cat << 'EOF' > ~/setup_ubuntu_scraper.sh
#!/bin/bash
# Update & install system packages
apt update -y && apt upgrade -y
apt install -y python3 python3-pip python3-venv git wget \
               libnss3 libatk1.0-0 libx11-xcb1 \
               libxcomposite1 libxdamage1 libxrandr2 \
               libgbm1 libasound2 fonts-liberation

# Gunakan Virtual Environment (Direkomendasikan di Ubuntu baru)
python3 -m venv ~/venv
source ~/venv/bin/activate

# Upgrade pip & install Python packages
pip install --upgrade pip
pip install scrapy scrapy-playwright fastapi uvicorn

# Install Playwright Browser Binaries
# Note: Di proot, Playwright kadang butuh flag khusus
playwright install chromium

# Clone scraper repo
cd ~
if [ ! -d "logam-mulia-scrapper" ]; then
    git clone https://github.com/ganiarto/logam-mulia-scrapper.git
fi
cd logam-mulia-scrapper

echo "------------------------------------------------"
echo "Setup selesai!"
echo "Untuk menjalankan, pastikan venv aktif: source ~/venv/bin/activate"
echo "Jalankan FastAPI: uvicorn api:app --host 0.0.0.0 --port 8100"
EOF

chmod +x ~/setup_ubuntu_scraper.sh

# 4. Salin script ke dalam Ubuntu (Path yang lebih aman)
echo "Menyalin script ke Ubuntu VM..."
# Menggunakan proot-distro login untuk memindahkan file dari host ke guest
cat ~/setup_ubuntu_scraper.sh | proot-distro login ubuntu -- bash -c "cat > /root/setup_ubuntu_scraper.sh && chmod +x /root/setup_ubuntu_scraper.sh"

echo "------------------------------------------------"
echo "✅ Script berhasil disiapkan!"
echo "Langkah selanjutnya:"
echo "1. Masuk ke Ubuntu: proot-distro login ubuntu"
echo "2. Jalankan setup:  ./setup_ubuntu_scraper.sh"