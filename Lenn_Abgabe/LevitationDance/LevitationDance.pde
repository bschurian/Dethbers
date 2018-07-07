/*
Lennart Egbers - poo()
 Generative Gestaltung 
 Beuth Hochschule für Technik Berlin
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
FFT fft;

int walkerAmount = 40;
float overlayAlpha = 50, amp, beatFloat;
Boolean punch = false, isMute = true;
Walker[] walkers = new Walker[walkerAmount];

void setup() {
  //size(600, 400);
  fullScreen();
  background(0);
  minim = new Minim(this);

  song = minim.loadFile("levitation.mp3", 2048);
  song.play();
  song.mute();

  fft = new FFT(song.bufferSize(), song.sampleRate());

  beat = new BeatDetect();
  ellipseMode(RADIUS);
  
  
  for (int i = 0; i<walkers.length; i++) {
    walkers[i] = new Walker(width/2, height/2);
  }
}

void draw() {
  fill(0, overlayAlpha);
  noStroke();
  rect(0, 0, width, height);
  
  // FFT for beat recognition
  fft.forward(song.mix);

  // Beat recognition
  if ( isBeat() ) {
    for (int i = 0; i<walkerAmount; i++) {
      walkers[i].beatWalk();
    }
  } else {
    for (int i = 0; i<walkerAmount; i++) {
      walkers[i].walk();
    }
  }
  
  // Show walker
  for (int i = 0; i<walkerAmount; i++) {
    walkers[i].show(beatFloat);
  }

  // Connect Walker
  for (int i = 0; i<walkerAmount; i++) {
    walkers[i].connectWalker(walkers);
  }
}


// -----  Controls - Mute song ------- //
void keyPressed() {
  if ( key == ' ' & isMute) {
    song.unmute();
    isMute = false;
  } else {
    song.mute();
    isMute = true;
  }
}
