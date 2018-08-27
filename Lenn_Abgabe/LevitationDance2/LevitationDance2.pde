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


int walkerAmount = 20;
Walker[] walkers = new Walker[walkerAmount];
float overlayAlpha = 50, amp, beatFloat;
int loStart = 0, loEnd = 100;
Boolean punch = false, isMute = true;

void setup() {
  //size(600, 400);
  fullScreen();

  minim = new Minim(this);

  song = minim.loadFile("levitation.mp3", 2048);
  song.play();
  song.mute();

  fft = new FFT(song.bufferSize(), song.sampleRate());
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
  ellipseMode(CENTER);
  //Create walker and add them to an ArrayList
  for (int i = 0; i<walkers.length; i++) {
    walkers[i] = new Walker(width/2, height/2);
  }
}

void draw() {
  // background(0);
  fill(0, overlayAlpha);
  noStroke();
  rect(0, 0, width, height);


  fft.forward(song.mix);
  if ( isBeat() ) {
    for (int i = 0; i<walkerAmount; i++) walkers[i].beatWalk();
  } else {
    for (int i = 0; i<walkerAmount; i++) walkers[i].walk();
  }

  // if the level gets quieter the walkers move in the middle 
  if (song.mix.level()<100) {
    // TODO: move the walker to the middle
  }


  for (int i = 0; i<walkerAmount; i++) walkers[i].show(beatFloat);

  for (int i = 0; i<walkerAmount; i++) walkers[i].connectWalker(walkers);
}

void keyPressed() {
  if ( key == 'm' || key == 'M' & isMute) {
    song.unmute();
    isMute = false;
  } else {
    song.mute();
    isMute = true;
  }
}

//LowPass filter
Boolean isBeat() {
  Boolean punch = false;
  for ( int i = loStart; i<loEnd; i++) {
    amp = fft.getFreq(i);

    beatFloat = fft.getFreq(i);
    if (amp>100) {
      punch = true;
    } else {
      punch = false;
    }
  }
  return punch;
}

//HiPass filter
float hiAction() {
  for ( int i = loEnd; i<20000; i++) {
    amp = fft.getFreq(i);
    if (amp>100) {
      
    } else {
      
    }
  }


  return 0.0;
}
