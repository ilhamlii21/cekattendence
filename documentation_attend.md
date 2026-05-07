# Absensi Barbershop API Documentation

**Version:** 1.0.0
**Base URL (Production):** `https://ada-backend-service.onrender.com`
**Base URL (Local):** `http://localhost:3000`
**Security:** Bearer Auth (JWT). Selalu sertakan token dalam header untuk endpoint yang membutuhkannya: `Authorization: Bearer <your_token>`.

---

## 1. Auth
Endpoints untuk autentikasi dan pendaftaran pengguna.

### Register User
Mendaftarkan pengguna baru (Admin/Employee/Owner).
- **URL:** `/auth/register`
- **Method:** `POST`
- **Security:** Bearer Auth (Sesuai dokumentasi, mungkin butuh akses admin/owner)
- **Body (`application/json`):**
  ```json
  {
    "name": "string",
    "email": "string",
    "password": "string",
    "role": "OWNER" // Pilihan: "OWNER", "ADMIN", "EMPLOYEE"
  }
  ```
- **Responses:**
  - `201 Created`: User registered successfully

### Login
Autentikasi pengguna dan mengembalikan token JWT.
- **URL:** `/auth/login`
- **Method:** `POST`
- **Body (`application/json`):**
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```
- **Responses:**
  - `200 OK`: Login successful (Mengembalikan JWT Token)

---

## 2. Attendance
Endpoints untuk absensi karyawan (Check-in & Check-out).

### Check-in
Mengirimkan permintaan *check-in* untuk shift pengguna saat ini.
- **URL:** `/attendance/check-in`
- **Method:** `POST`
- **Security:** Bearer Auth
- **Body (`application/json`):**
  ```json
  {
    "qrToken": "string",  // Token hasil scan QR dari Barbershop
    "latitude": 0,        // Lokasi GPS Karyawan (Latitude)
    "longitude": 0        // Lokasi GPS Karyawan (Longitude)
  }
  ```
- **Responses:**
  - `201 Created`: Checked in successfully

### Check-out
Mengirim permintaan *check-out*, menandakan akhir dari shift karyawan.
- **URL:** `/attendance/check-out`
- **Method:** `POST`
- **Security:** Bearer Auth
- **Body:** Tidak ada
- **Responses:**
  - `200 OK`: Checked out successfully

---

## 3. Barbershops
Endpoints untuk manajemen cabang barbershop dan QR Code absen.

### Get Barbershops
Mengambil daftar seluruh cabang barbershop.
- **URL:** `/barbershops`
- **Method:** `GET`
- **Security:** Bearer Auth
- **Responses:**
  - `200 OK`: A list of barbershops

### Create Barbershop
Membuat cabang barbershop baru.
- **URL:** `/barbershops`
- **Method:** `POST`
- **Security:** Bearer Auth
- **Body (`application/json`):**
  ```json
  {
    "name": "string",
    "address": "string",
    "regionId": "string"
  }
  ```
- **Responses:**
  - `201 Created`: Barbershop created successfully

### Delete Barbershop
Menghapus spesifik cabang barbershop berdasarkan ID.
- **URL:** `/barbershops/{id}`
- **Method:** `DELETE`
- **Security:** Bearer Auth
- **Path Parameters:**
  - `id` (string): ID dari barbershop
- **Responses:**
  - `200 OK`: Barbershop deleted successfully

### Get Barbershop QR Token
Mendapatkan token QR statis saat ini untuk cabang barbershop tertentu. Digunakan untuk ditampilkan di aplikasi/layar cabang.
- **URL:** `/barbershops/{id}/qr`
- **Method:** `GET`
- **Security:** Bearer Auth
- **Path Parameters:**
  - `id` (string): ID dari barbershop
- **Responses:**
  - `200 OK`: QR Token retrieved successfully

### Refresh Barbershop QR Token
Memperbarui atau mereset token QR statis untuk cabang barbershop. Berguna untuk alasan keamanan agar token QR tidak selalu sama.
- **URL:** `/barbershops/{id}/refresh-qr`
- **Method:** `PUT`
- **Security:** Bearer Auth
- **Path Parameters:**
  - `id` (string): ID dari barbershop
- **Responses:**
  - `200 OK`: QR Token refreshed successfully

---

## 4. Regions
Endpoints untuk manajemen wilayah perusahaan (Khusus Owner).

### Get Regions
Mengambil daftar seluruh wilayah.
- **URL:** `/regions`
- **Method:** `GET`
- **Security:** Bearer Auth
- **Responses:**
  - `200 OK`: A list of regions

### Create Region
Membuat wilayah baru di dalam perusahaan.
- **URL:** `/regions`
- **Method:** `POST`
- **Security:** Bearer Auth
- **Body (`application/json`):**
  ```json
  {
    "name": "string"
  }
  ```
- **Responses:**
  - `201 Created`: Region created successfully

### Delete Region
Menghapus spesifik wilayah berdasarkan ID.
- **URL:** `/regions/{id}`
- **Method:** `DELETE`
- **Security:** Bearer Auth
- **Path Parameters:**
  - `id` (string): ID dari region
- **Responses:**
  - `200 OK`: Region deleted successfully
