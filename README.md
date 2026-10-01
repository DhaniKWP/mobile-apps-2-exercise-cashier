# Anggota Kelompok

Dhani Kusuma Wardana Putra

Maulana Khadafi

--

## 1. Requirement & Business Rule

| Kode | Isi |
| :--- | :--- |
| **FR-01** | Sistem dapat menghitung persen diskon, nominal potongan, dan total akhir belanja. |
| **FR-02** | Sistem menampilkan hasil total bayar yang harus dibayarkan pelanggan. |
| **BR-01** | Belanja minimal Rp100.000 mendapat diskon 10%. |
| **BR-02** | Member mendapat tambahan diskon 5% (hanya jika BR-01 terpenuhi). |
| **BR-03** | Total potongan maksimal Rp25.000. |

## 2. Input, Output, Abstraction

| Aspek | Hasil Analisis |
| :--- | :--- |
| **Input** | `totalBelanja` (double), `membership` (bool) |
| **Output** | `totalBayar` (double) |
| **Abstraction** | `hitungPersenDiskon(totalBelanja, membership)`, `hitungPotongan(diskon, totalBelanja)`, `hitungTotalBayar(totalBelanja, membership)` |

## 3. Decomposition

Hierarki fungsi dipecah secara modular untuk memenuhi aturan bisnis (*Single Responsibility Principle*):

```
```text
hitungTotalBayar
├── hitungPersenDiskon
│   ├── cek minimal belanja Rp100.000         (BR-01)
│   └── cek membership (+5% diskon jika true)  (BR-02)
├── hitungPotongan
│   ├── kalikan persen diskon * totalBelanja
│   └── terapkan batas maksimal Rp25.000      (BR-03)
└── kurangi totalBelanja dengan potongan

```

## 4. Flowchart Logika

```
START
                 |
                 v
   Input totalBelanja, membership
                 |
                 v
      /---------------------\
     < totalBelanja >= 100k? > ----- Tidak -----> diskon = 0
      \---------------------/                        |
                 |                                   |
                Ya                                   |
                 v                                   |
         /---------------\                           |
        <  membership ==  > --- Tidak -> diskon = 0.10
        <     true?       >                           |
         \---------------/                           |
                 |                                   |
                Ya                                   |
                 v                                   |
           diskon = 0.15                             |
                 |                                   |
                 +<----------------------------------+
                 |
                 v
     potongan = diskon * totalBelanja
                 |
                 v
        /-----------------\
       < potongan >= 25k?  > ----- Ya -----> potongan = 25000
        \-----------------/                      |
                 |                               |
               Tidak                             |
                 |                               |
                 +<------------------------------+
                 |
                 v
   totalBayar = totalBelanja - potongan
                 |
                 v
         Tampilkan totalBayar
                 |
                 v
                END

```

## 5. Implementasi Kode Sumber (Dart)

```
/// Langkah 1: Menentukan persentase diskon
double hitungPersenDiskon(double totalBelanja, bool membership) {
  if (totalBelanja >= 100000 && membership == true) {
    return 0.15;
  }
  if (totalBelanja >= 100000 && membership == false) {
    return 0.10;
  }
  return 0;
}

/// Langkah 2: Menghitung nominal potongan & menerapkan batas atas (capping)
double hitungPotongan(double diskon, double totalBelanja) {
  double potongan = diskon * totalBelanja;
  if (potongan >= 25000) {
    return 25000;
  }
  return potongan;
}

/// Langkah 3: Menggabungkan sub-fungsi untuk menghitung total pembayaran
double hitungTotalBayar(double totalBelanja, bool membership) {
  double persen = hitungPersenDiskon(totalBelanja, membership);
  double potongan = hitungPotongan(persen, totalBelanja);

  double totalBayar = totalBelanja - potongan;
  return totalBayar;
}

/// Eksekusi pengujian kasus
void main() {
  print(hitungTotalBayar(80000, false));   // Output: 80000.0
  print(hitungTotalBayar(150000, false));  // Output: 135000.0
  print(hitungTotalBayar(150000, true));   // Output: 127500.0
  print(hitungTotalBayar(300000, true));   // Output: 275000.0
}

```

## 6. Simulasi & Verifikasi Uji Kasus (*Trace Table*)

| Kasus Uji | Total Belanja | Membership | Persen Diskon | Perhitungan Awal | Batas Maks (Rp 25.000) | Potongan Akhir | Total Bayar | 
 | ----- | ----- | ----- | ----- | ----- | ----- | ----- | ----- | 
| **Kasus 1** | Rp 80.000 | `false` | $0\%$ | $0 \times 80.000 = 0$ | Tidak terkena batas | Rp 0 | **Rp 80.000** | 
| **Kasus 2** | Rp 150.000 | `false` | $10\%$ | $0.10 \times 150.000 = 15.000$ | Belum capai batas | Rp 15.000 | **Rp 135.000** | 
| **Kasus 3** | Rp 150.000 | `true` | $15\%$ | $0.15 \times 150.000 = 22.500$ | Belum capai batas | Rp 22.500 | **Rp 127.500** | 
| **Kasus 4** | Rp 300.000 | `true` | $15\%$ | $0.15 \times 300.000 = 45.000$ | **Kena batas** $\ge 25.000$ | Rp 25.000 | **Rp 275.000** | 
