// -----  LowPass Filter ------- //

int loStart = 20, loEnd = 100;

Boolean isBeat() {
  Boolean punch = false;
  for ( int i = loStart; i<loEnd; i++) {
    amp = fft.getFreq(i);

    beatFloat = fft.getFreq(i);
    if (amp>90) {
      println(fft.getFreq(60));
      punch = true;
    } else {
      punch = false;
    }
  }
  return punch;
}
