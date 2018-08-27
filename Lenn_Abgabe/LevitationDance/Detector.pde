// ---------- BEAT DETECTION CLASS ----------//
class Detector {

  AudioPlayer songLow;
  AudioPlayer songHigh;
  Boolean hit;
  BeatDetect beat;
  int cutoffFreq = 200; // Cutoff frequency of low pass filter
  
  LowPassFS lowPass;    // Low pass filter
  HighPassSP highPass;  // High pass filter

  Detector(AudioPlayer song_) {
    songLow = song_;
    songHigh = song_;
    beat = new BeatDetect();
    lowPass = new LowPassFS(cutoffFreq, song_.sampleRate());
    highPass = new HighPassSP(cutoffFreq, song_.sampleRate());
    songLow.addEffect(lowPass);
    //songHigh.addEffect(highPass);
  }
  
  int getBeatLevel(){
    int beatLevel = beat.detectSize();
    return beatLevel;
  }

  Boolean hits() {
    beat.detect(songLow.mix);
    if ( beat.isOnset() ) {
      hit = true;
    } else {
      hit = false;
    }
    return hit;
  }
}
