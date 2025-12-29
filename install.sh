#!/data/data/com.termux/files/usr/bin/bash

# 1. Update Termux dan Install proot-distro
echo "Mengupdate Termux..."
pkg update -y && pkg upgrade -y
pkg install -y proot-distro git

# 2. Install Ubuntu (jika belum ada)
if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu" ]; then
    echo "Menginstal Ubuntu VM..."
    proot-distro install ubuntu
fi

# 3. Membuat script "setup_didalam_ubuntu.sh" secara otomatis
cat << 'EOF' > setup_ubuntu_internal.sh
#!/bin/bash
echo "--- Memulai setup di dalam Ubuntu ---"
apt update -y && apt upgrade -y

# Install Python dan dependencies sistem
apt install -y python3 python3-pip python3-venv python3-full git wget \
               libnss3 libatk1.0-0 libx11-xcb1 \
               libxcomposite1 libxdamage1 libxrandr2 \
               libgbm1 libasound2t64 fonts-liberation

# Setup Virtual Environment
cd ~
rm -rf ~/venv
python3 -m venv ~/venv
source ~/venv/bin/activate

# Clone Repo
if [ ! -d "logam-mulia-scrapper" ]; then
    git clone https://github.com/ganiarto/logam-mulia-scrapper.git
fi

# Install Python Libraries
cd ~/logam-mulia-scrapper
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi
pip install scrapy-playwright fastapi uvicorn

# Install Browser Playwright
playwright install chromium

echo "-------------------------------------------------------"
echo "✅ SETUP DI DALAM UBUNTU BERHASIL!"
echo "-------------------------------------------------------"
echo "Cara menjalankan server:"
echo "1. proot-distro login ubuntu"
echo "2. source ~/venv/bin/activate"
echo "3. cd ~/logam-mulia-scrapper"
echo "4. uvicorn api:app --host 0.0.0.0 --port 8100"
echo "-------------------------------------------------------"
EOF

# 4. Masukkan script setup tadi ke dalam Ubuntu VM
echo "Menyalin script ke dalam Ubuntu..."
mv setup_ubuntu_internal.sh $PREFIX/var/lib/proot-distro/installed-rootfs/ubuntu/root/

# 5. Jalankan script setup tersebut DARI DALAM Ubuntu secara otomatis
echo "Menjalankan installer di dalam Ubuntu VM (Mohon tunggu...)"
proot-distro login ubuntu -- bash /root/setup_ubuntu_internal.sh