# CekAttendence

Cek fitur dengan QR Code scanning dan autentikasi JWT yang aman.

## Fitur Utama

### 1. Login & Autentikasi
- Login menggunakan **email** dan **password** ke backend API
- Backend mengembalikan **JWT Token** sebagai bukti autentikasi
- Token disimpan secara aman menggunakan **Secure Storage** (terenkripsi)
- Tidak ada token yang di-hardcode dalam source code

### 2. Secure Storage (Penyimpanan Token Aman)
Aplikasi menggunakan `flutter_secure_storage` untuk menyimpan JWT Token secara terenkripsi di device.

**Mengapa tidak pakai SharedPreferences?**
| | SharedPreferences | Secure Storage |
|---|---|---|
| Format penyimpanan | Plain text (bisa dibaca) | Terenkripsi |
| Android | File XML biasa | AES encryption via Android Keystore |
| iOS | UserDefaults (plain text) | Apple Keychain (encrypted) |
| Keamanan | ❌ Rendah | ✅ Tinggi |

**Fungsi-fungsi Secure Storage Service:**
- `saveToken(token)` — Menyimpan JWT token setelah login berhasil
- `getToken()` — Mengambil JWT token saat akan memanggil API (check-in/check-out)
- `deleteToken()` — Menghapus JWT token saat user logout
- `hasToken()` — Mengecek apakah user sudah login (ada token tersimpan)

**Singleton Pattern:** Service menggunakan singleton agar seluruh bagian aplikasi mengakses instance storage yang sama, sehingga token yang disimpan di satu controller bisa diakses di controller lainnya.

### 3. QR Code Scanner
- Scan QR Code barbershop menggunakan kamera device via `mobile_scanner`
- QR Code berisi **QR Token** unik dari masing-masing cabang barbershop
- Token QR digunakan sebagai parameter saat melakukan check-in

### 4. Attendance (Check-in & Check-out)
- **Check-in**: Mengirim data QR token + koordinat GPS (latitude & longitude) ke backend
- **Check-out**: Mengirim request check-out (tanpa body, hanya perlu JWT token)
- Semua request menggunakan JWT token dari Secure Storage di header `Authorization: Bearer <token>`

### 5. Error Handling
Aplikasi menampilkan pesan error yang informatif berdasarkan situasi:
| Situasi | Pesan |
|---|---|
| Tidak ada internet | "Tidak ada koneksi internet. Periksa WiFi/data kamu." |
| Token expired/invalid | "Token tidak valid atau sudah expired. Silakan login ulang." |
| QR token salah/expired | Pesan langsung dari backend atau fallback message |
| Sudah check-in sebelumnya | "Konflik — mungkin sudah check-in/check-out sebelumnya." |
| Server down | "Server sedang bermasalah. Coba lagi nanti." |
| Timeout | "Koneksi timeout. Server terlalu lama merespons." |

## Arsitektur (MVC Pattern)

```
lib/
├── main.dart                              # Entry point, dimulai dari LoginView
├── controllers/
│   ├── auth_controller.dart               # Logic login, logout, cek sesi
│   ├── attendance_controller.dart         # Logic check-in & check-out
│   └── barbershop_controller.dart         # Logic ambil data barbershop
├── models/
│   ├── check_in_request.dart              # Model request check-in
│   └── barbershop.dart                    # Model data barbershop
├── services/
│   ├── auth_api_service.dart              # API call login
│   ├── attendance_api_service.dart        # API call attendance & barbershop
│   └── secure_storage_service.dart        # Simpan/ambil/hapus token (encrypted)
└── views/
    ├── login_view.dart                    # Halaman login
    ├── attendance_test_view.dart          # Halaman check-in & check-out
    ├── barbershop_list_view.dart          # Halaman daftar barbershop
    └── qr_scanner_view.dart              # Halaman scan QR Code
```

## Flow Aplikasi

```
Login (email + password)
  │
  ▼
Backend mengembalikan JWT Token
  │
  ▼
Token disimpan di Secure Storage (terenkripsi)
  │
  ▼
Halaman Attendance
  ├── Scan QR Code barbershop
  ├── Check-in (kirim qrToken + GPS + JWT)
  └── Check-out (kirim JWT saja)
```

## API Endpoints

| Endpoint | Method | Fungsi | Auth |
|---|---|---|---|
| `/auth/login` | POST | Login, dapat JWT token | Tidak |
| `/attendance/check-in` | POST | Absen masuk | Bearer Token |
| `/attendance/check-out` | POST | Absen pulang | Bearer Token |
| `/barbershops` | GET | Daftar barbershop | Bearer Token |

**Base URL:** `https://ada-backend-service.onrender.com`

## Dependencies

- `http` — HTTP client untuk API calls
- `flutter_secure_storage` — Penyimpanan terenkripsi untuk JWT token
- `mobile_scanner` — QR Code scanner via kamera
