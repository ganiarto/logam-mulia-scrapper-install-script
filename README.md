# 🪙 Logam Mulia Scraper (Termux - Ubuntu VM Setup)

Script ini dirancang untuk mempermudah instalasi lingkungan scraping otomatis di Android menggunakan **Termux**. Script akan menyiapkan **Ubuntu VM**, menginstal **Python**, **Scrapy**, **Playwright (Chromium)**, dan **FastAPI**.

## 🛠️ Langkah Awal: Persiapan & Cara Download

Jika kamu baru pertama kali menggunakan Termux atau Git, ikuti langkah-langkah di bawah ini:

### 1. Install Termux & Git

Buka aplikasi Termux, lalu ketik perintah berikut satu per satu:

```bash
pkg update -y
pkg upgrade -y
pkg install git -y

```

### 2. Download (Clone) Script ini

Ketik perintah ini untuk mengambil folder script dari internet ke HP kamu:

```bash
git clone https://github.com/ganiarto/logam-mulia-scrapper-install-script.git
cd logam-mulia-scrapper-install-script

```

---

## 🚀 Cara Instalasi Sistem

### 1. Jalankan Script Installer Utama

Berikan izin akses lalu jalankan script untuk membangun Ubuntu:

```bash
chmod +x install.sh
./install.sh

```

### 2. Masuk ke Lingkungan Ubuntu

Setelah proses di atas selesai, kamu harus masuk ke "komputer virtual" Ubuntu dengan perintah:

```bash
proot-distro login ubuntu

```

### 3. Jalankan Setup Internal

Sekarang kamu sudah berada di dalam Ubuntu (tanda `root@localhost`). Jalankan script terakhir ini:

```bash
./setup_ubuntu_scraper.sh

```

*Proses ini akan mengunduh semua tools Python dan Browser. Tunggu sampai muncul tulisan "Setup Selesai!".*

---

## 🏃 Cara Menjalankan Scraper & API

Setelah semuanya siap, ikuti langkah berikut setiap kali ingin bekerja:

1. **Aktifkan Lingkungan Python (Venv):**
```bash
source ~/venv/bin/activate

```


2. **Masuk ke Folder Project:**
```bash
cd ~/logam-mulia-scrapper

```


3. **Jalankan API:**
```bash
uvicorn api:app --host 0.0.0.0 --port 8100

```


*Sekarang kamu bisa melihat data lewat browser HP di alamat: `http://localhost:8100*`

---

## ⚠️ Tips untuk Pemula

* **Keyboard**: Gunakan tombol Volume Atas + `Q` pada keyboard HP untuk memunculkan tombol kontrol (seperti Tab, Ctrl, Alt) di Termux.
* **Copy-Paste**: Di Termux, tekan lama pada layar untuk memunculkan menu **Paste**.
* **Keluar**: Untuk keluar dari Ubuntu kembali ke Termux biasa, ketik `exit`.

---