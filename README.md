# 📱 Temulik

<div align="center">

![Temulik Banner](https://img.shields.io/badge/Temulik-Lost%20%26%20Found%20App-6366F1?style=for-the-badge&logoColor=white)

[![Flutter](https://img.shields.io/badge/Flutter-Mobile%20App-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=flat-square&logo=firebase&logoColor=black)](https://firebase.google.com/)
[![Firestore](https://img.shields.io/badge/Firestore-Database-FF7139?style=flat-square&logo=firebase&logoColor=white)](https://firebase.google.com/docs/firestore)
[![Figma](https://img.shields.io/badge/Figma-Design-F24E1E?style=flat-square&logo=figma&logoColor=white)](https://figma.com/)

</div>

---

## 📋 Daftar Isi

- [Tentang Proyek](#-tentang-proyek)
- [Fitur Utama](#-fitur-utama)
- [Tech Stack](#-tech-stack)
- [Struktur Data](#-struktur-data)
- [Cara Menjalankan](#-cara-menjalankan)
- [Context Proyek](#-context-proyek)
- [Presentation](#-presentation)

---

## 🔍 Tentang Proyek

**Temulik** adalah aplikasi mobile berbasis **geolokasi** dan **gamifikasi** yang dirancang untuk membantu mahasiswa menemukan barang hilang di lingkungan kampus secara lebih efektif dan interaktif.

Aplikasi ini memungkinkan pengguna untuk melaporkan barang hilang, mencari barang yang ditemukan, serta berinteraksi melalui sistem yang mendorong partisipasi aktif pengguna.

### 🎯 Tujuan Sistem
- Mempermudah proses **pelaporan dan pencarian barang hilang**
- Menggunakan **geolocation** untuk mempercepat pencarian
- Meningkatkan engagement pengguna melalui **gamification system**
- Menyediakan platform yang **user-friendly dan efisien**

---

## ✨ Fitur Utama

### 📍 Sistem Berbasis Lokasi
- Menampilkan lokasi barang hilang / ditemukan
- Membantu pengguna menemukan barang berdasarkan area terdekat

### 🎮 Gamifikasi
- Sistem interaksi untuk meningkatkan partisipasi pengguna
- Mendorong user untuk aktif membantu sesama

### 🔐 Autentikasi User
- Login & register menggunakan Firebase Authentication
- Data user tersimpan aman di Firestore

### 📱 UI/UX Mobile
- Desain clean dan intuitif
- Fokus pada kemudahan penggunaan

---

## 🛠 Tech Stack

| Teknologi | Peran |
|----------|------|
| **Flutter** | Framework pengembangan aplikasi mobile |
| **Firebase Auth** | Sistem autentikasi pengguna |
| **Firestore** | Database NoSQL untuk menyimpan data |
| **Figma** | Desain UI/UX aplikasi |

---

## 📊 Struktur Data

```
users (collection)
├── {userId}
├── email (string)
├── photoUrl (string)
├── fullName (string)
├── nim (string)
├── faculty (string)
├── department (string)
├── year (number)
├── whatsapp (string)
├── address (string)
└── createdAt (timestamp)
```

---

## 🚀 Cara Menjalankan

Jika terjadi error:

```
flutter clean
flutter pub get
flutter run
```

Run di web:

```
flutter run -d edge --web-renderer html
```

---

## 📂 Context Proyek

Proyek ini dikembangkan sebagai **tugas akhir mata kuliah Pemrograman Mobile** dan diikutsertakan dalam:

🏆 **PKM Rektor Cup IV - Skema Karsa Cipta**

---

## 📑 Presentation

- PKM: https://www.canva.com/design/DAGVrDNFWlg/YXn-PAlcDoeVTgBQpqqxVw/edit  
- MPI: https://www.canva.com/design/DAGW_lZi5hw/hJr9a5a2KCSZPBvc8GkpXA/edit  
- Proposal: https://www.canva.com/design/DAGSMEtYqsI/cwZO2EVbcYo4AnORa04kfg/edit  
- Progress: https://www.canva.com/design/DAGWyCdfTCQ/oXOpouYJEPdUagfQlkikpA/edit  

---

<div align="center">

📱 *Solusi modern untuk masalah klasik: kehilangan barang.*

</div>
