// ---------- BEAT DETECTION CLASS ----------//

class Detector {

  AudioPlayer song;
  Boolean hit;
  BeatDetect beat;
  int cutoffFreq = 100; // Cutoff frequency of low pass filter


  // ---------- Variables for FFT ----------//
  int bands = 1024;
  float[] spectrum = new float[bands];
  LowPassFS lowPass;    // Low pass filter
  FFT fft;

  // ---------- Variables for control ----------//
  float sampleRate; // 44.1 kHz
  int specSize;
  float getBand;

  Detector(AudioPlayer song_) {
    song = song_;
    beat = new BeatDetect();
    lowPass = new LowPassFS(cutoffFreq, song_.sampleRate());
    song.addEffect(lowPass);
  }

  Boolean hits() {
    beat.detect(song.mix);
    if ( beat.isOnset() ) {
      hit = true;
    } else {
      hit = false;
    }
    return hit;
  }
}
