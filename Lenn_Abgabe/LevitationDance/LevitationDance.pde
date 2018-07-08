/* //<>// //<>//
Lennart Egbers - poo()
 Generative Gestaltung 
 Beuth Hochschule für Technik Berlin
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;

int walkerAmount = 20;
float overlayAlpha = 50, amp, beatFloat;
Boolean isMute = true;
Walker[] walkers = new Walker[walkerAmount];
Detector detector;
FFT fft;

void setup() {
  size(600, 400);
  //size(1920, 1080);
  //fullScreen();
  background(0);
  minim = new Minim(this);

  song = minim.loadFile("levitation.mp3", 2048);
  song.play();
  detector = new Detector(song);
  song.mute();

  ellipseMode(RADIUS);

  for (int i = 0; i<walkers.length; i++) {
    walkers[i] = new Walker(width/2, height/2);
  }
}

void draw() {
  fill(0, overlayAlpha);
  noStroke();
  rect(0, 0, width, height);

  //detector.run();

  // Animation at kick hit
  if ( detector.hits() ) {
    for (int i = 0; i<walkerAmount; i++) {
      walkers[i].beatWalk();
    }
  } else {
    for (int i = 0; i<walkerAmount; i++) {
      walkers[i].walk();
    }
  }

  beatFloat = 10;
  // Show walker
  for (int i = 0; i<walkerAmount; i++) {
    walkers[i].show(beatFloat);
  }

  // Connect Walker
  for (int i = 0; i<walkerAmount; i++) {
    walkers[i].connectWalker(walkers, walkerAmount);
  }


  fill(250);
  text(frameRate, 10, 10);
}

/* void stop() {
 song.close();
 minim.stop();
 super.stop();
 } */

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
