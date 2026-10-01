# Anggota Kelompok

Dhani Kusuma Wardana Putra

Maulana Khadafi

--

## 1. Requirement & Business Rule

| Kode | Isi | 
 | ----- | ----- | 
| **FR-01** | Sistem dapat menentukan persentase diskon berdasarkan nilai belanja dan status keanggotaan. | 
| **FR-02** | Sistem dapat menghitung nominal potongan harga dengan batasan kuota diskon maksimal. | 
| **FR-03** | Sistem dapat menghitung total akhir yang harus dibayar oleh pelanggan. | 
| **BR-01** | Total belanja minimal untuk mendapatkan diskon adalah Rp 100.000. Belanja di bawah Rp 100.000 mendapatkan diskon $0\%$. | 
| **BR-02** | Pelanggan dengan status *member* (`membership == true`) dan belanja $\ge$ Rp 100.000 memperoleh diskon sebesar $15\%$ ($0.15$). | 
| **BR-03** | Pelanggan tanpa *member* (`membership == false`) dan belanja $\ge$ Rp 100.000 memperoleh diskon sebesar $10\%$ ($0.10$). | 
| **BR-04** | Nominal potongan diskon maksimal adalah Rp 25.000. Jika hasil perhitungan diskon melebihi Rp 25.000, maka potongan ditetapkan tepat Rp 25.000. | 

## 2. Input, Output, Abstraction

| Aspek | Hasil Analisis | 
 | ----- | ----- | 
| **Input** | `totalBelanja` (`double`), `membership` (`bool`) | 
| **Output** | `totalBayar` (`double`), `potongan` (`double`), `persenDiskon` (`double`) | 
| **Abstraction** | \- Fungsi `hitungPersenDiskon(totalBelanja, membership)`  \- Fungsi `hitungPotongan(diskon, totalBelanja)`  \- Fungsi `hitungTotalBayar(totalBelanja, membership)` | 

## 3. Decomposition

Hierarki fungsi dipecah secara modular untuk memenuhi aturan bisnis (*Single Responsibility Principle*):

```
hitungTotalBayar
├── hitungPersenDiskon   → Menentukan tarif diskon 0%, 10%, atau 15%      (BR-01, BR-02, BR-03)
├── hitungPotongan       → Menghitung nominal diskon & capping Rp 25.000   (BR-04)
└── hitungTotalBayar     → totalBelanja - potongan                        (FR-03)

```

## 4. Flowchart Logika

```
flowchart TD
    START([START]) --> Input[/Input: totalBelanja, membership/]
    Input --> CekBelanja{totalBelanja >= 100000?}
    
    CekBelanja -- Tidak --> DiskonNol[persen = 0.0]
    CekBelanja -- Ya --> CekMember{membership == true?}
    
    CekMember -- Ya --> DiskonMember[persen = 0.15]
    CekMember -- Tidak --> DiskonNonMember[persen = 0.10]
    
    DiskonNol --> HitungNominal[potongan = persen * totalBelanja]
    DiskonMember --> HitungNominal
    DiskonNonMember --> HitungNominal
    
    HitungNominal --> CekMaksimal{potongan >= 25000?}
    
    CekMaksimal -- Ya --> SetMax[potongan = 25000]
    CekMaksimal -- Tidak --> KeepPotongan[potongan tetap]
    
    SetMax --> HitungAkhir[totalBayar = totalBelanja - potongan]
    KeepPotongan --> HitungAkhir
    
    HitungAkhir --> Output[/Output: totalBayar/]
    Output --> END([END])

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
