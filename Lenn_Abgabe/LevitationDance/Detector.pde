// ---------- BEAT DETECTION CLASS ----------//
class Detector {

  AudioPlayer song;
  Boolean hit;
  BeatDetect beat;
  int cutoffFreq = 100; // Cutoff frequency of low pass filter
  
  LowPassFS lowPass;    // Low pass filter

  Detector(AudioPlayer song_) {
    song = song_;
    beat = new BeatDetect();
    lowPass = new LowPassFS(cutoffFreq, song_.sampleRate());
    song.addEffect(lowPass);
  }
  
  int getBeatLevel(){
    int beatLevel = beat.detectSize();
    return beatLevel;
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
