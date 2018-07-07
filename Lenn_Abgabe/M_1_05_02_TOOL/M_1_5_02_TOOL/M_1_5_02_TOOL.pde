import processing.opengl.*;

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;

// ------ agents ------
Agent[] agents = new Agent[10000]; // create more ... to fit max slider agentsCount
int agentsCount = 4000;
float noiseScale = 300, noiseStrength = 10; 
float overlayAlpha = 10, agentsAlpha = 90, strokeWidth = 0.3;
int drawMode = 1;

void setup() {
  size(1280, 800, P3D);
  smooth();
  
  minim = new Minim(this);
  song = minim.loadFile("levitation.mp3", 2048);
  song.play();
  // a beat detection object song SOUND_ENERGY mode with a sensitivity of 10 milliseconds
  beat = new BeatDetect();
  
  
  for (int i=0; i<agents.length; i++) {
    agents[i] = new Agent();
  }
}

void draw() {
  fill(255, overlayAlpha);
  noStroke();
  rect(0, 0, width, height);

  beat.detect(song.mix);
  
  if ( beat.isOnset() ){
    int newNoiseSeed = (int) random(100000);
    noiseSeed(newNoiseSeed);
  }

  stroke(0, agentsAlpha);
  //draw agents
  if (drawMode == 1) {
    for (int i=0; i<agentsCount; i++) agents[i].update1();
  } else {
    for (int i=0; i<agentsCount; i++) agents[i].update2();
  }
}


void keyReleased() {
  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  //if (key=='s' || key=='S') saveFrame(timestamp()+".png");
  if (key == ' ') {
    int newNoiseSeed = (int) random(100000);
    println("newNoiseSeed: "+newNoiseSeed);
    noiseSeed(newNoiseSeed);
  }
  if (key == DELETE || key == BACKSPACE) background(255);
}
