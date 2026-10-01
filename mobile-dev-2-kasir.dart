double hitungPersenDiskon(double totalBelanja, bool membership){
  if (totalBelanja >= 100000 && membership == true) {
    return 0.15;
  }
  if (totalBelanja >= 100000 && membership == false) {
    return 0.10;
  }
  return 0;
}

double hitungPotongan(double diskon, double totalBelanja) {
  double potongan = diskon * totalBelanja;
  if (potongan >= 25000){
    return 25000;
  }
  return potongan;
}

double hitungTotalBayar(double totalBelanja, bool membership){

  double persen = hitungPersenDiskon(totalBelanja, membership);
  double potongan = hitungPotongan(persen, totalBelanja);

  double totalBayar = totalBelanja - potongan;

  return totalBayar;

}
void main() {
  print(hitungTotalBayar(80000,false));
  print(hitungTotalBayar(150000,false));
  print(hitungTotalBayar(150000,true));
  print(hitungTotalBayar(300000,true));
}
