/* //<>//
Lennart Egbers - poo()
 Generative Gestaltung 
 Beuth Hochschule für Technik Berlin
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer songDetect;
AudioPlayer songPlayer;
AudioOutput out;

int walkerAmount = 20, connectCount = 3, beatInt;
float overlayAlpha = 50, amp;
Boolean isMute = true;
Walker[] walkers = new Walker[walkerAmount];
Detector detector;

void setup() {
  size(600, 400);
  //size(1920, 1080);
  //fullScreen();
  background(0);
  frameRate(60);
  
  minim = new Minim(this);

  songDetect = minim.loadFile("levitation.mp3", 2048); // this song for detection
  songPlayer = minim.loadFile("levitation.mp3", 2048);// this song for output sound
  songDetect.play();
  detector = new Detector(songDetect); // Detection with the songDetect
  songPlayer.play();
  songDetect.mute();

  ellipseMode(RADIUS);

  for (int i = 0; i<walkers.length; i++) {
    walkers[i] = new Walker(width/2, height/2);
  }
}

void draw() {
  fill(0, overlayAlpha);
  noStroke();
  rect(0, 0, width, height);

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

  beatInt = detector.getBeatLevel();
  // Show walker
  for (int i = 0; i<walkerAmount; i++) {
    walkers[i].show(beatInt);
  }

  // Connect Walker
  for (int i = 0; i<walkerAmount; i++) {
    walkers[i].connectWalker(walkers);
  }


  println(frameRate);
  //fill(250);
  //text(frameRate, 10, 20);
}

void stop() {
  songDetect.close();
  songPlayer.close();
  minim.stop();
  super.stop();
} 



// -----  Controls - Mute song ------- //
void keyPressed() {
  if ( key == ' ' & isMute) {
    songDetect.unmute();
    isMute = false;
  } else {
    songDetect.mute();
    isMute = true;
  }
}
